/*
 * Encoding ISO-8859-1
 * Make sure following 3 characters look ok: ���
 */

package se.idainfront.egov.server.fgs.scripts

import groovy.transform.Field

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Set;
import java.util.Stack;
import java.util.TreeSet;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathException;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import iipax.business.lta.api.exception.MetaDataError;
import iipax.business.lta.sa.AIPConfigurationNotFoundException;
import iipax.business.lta.sa.SubmissionAgreementManager;
import iipax.generic.base.BaseConfiguration;

import se.idainfront.egov.common.exception.IngestException;
import se.idainfront.egov.common.ProducerSystem;
import se.idainfront.egov.ingest.fgs.util.FgsUtil;
import se.idainfront.egov.ingest.fgs.util.FileUtil;
import se.idainfront.egov.ingest.fgs.file.FileInfo;
import se.idainfront.egov.ingest.fgs.xml.ArchiveXml;
import se.idainfront.egov.ingest.fgs.xml.Attribute;
import se.idainfront.egov.ingest.fgs.xml.XMLUtil;


@Field String mTargetDirName

//@Field FileInputStream mInputStream
@Field BufferedInputStream mInputStream

@Field Boolean mDebug = true
@Field Boolean mIsCli = false



if (args != null && args.size() != 0) {
    println "Running in command line mode"
    // Will not get here if called by iipax, only when called from command line with the given example
    
    // Where to store the output of the script
    mTargetDirName = "C:\\temp\\fgs-test"
    // Where to find the .zip to process
    mInputStream = new BufferedInputStream(new FileInputStream("C:\\temp\\referens4.zip"))
    

    mDebug = true
    mIsCli = true
}
else {
    mTargetDirName = targetDirName
    mInputStream = inputStream
}

if (mDebug) {println "Starting FGS transformation"}


@Field ProducerSystem mProducerSystem;

@Field DocumentBuilderFactory mDbFactory;

@Field DocumentBuilder mDocBuilder;

@Field Path mCaseFile;

@Field Path mSipFile;

@Field String mDefaultCase = "byggR_arende";

@Field String mDefaultDocument = "byggR_handling";

@Field String mDefaultCaseType = "-";

@Field HashMap<String, FileInfo> mFileToHash;

@Field SimpleDateFormat sSdfFrom = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

@Field SimpleDateFormat sSdfFromWithMillis =
        new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.S");

@Field List<Attribute> mDefaultAttributes = new ArrayList<Attribute>();

/*
 * Anv�nds f�r att s�tta standard attribut p� �rendet.
 * Kommentera bort om det inte ska anv�ndas
 */
//Attribute a1 = new Attribute("case_type", mDefaultCaseType);
//mDefaultAttributes.add(a1);

@Field boolean mStoreOriginalCaseXML = true;

@Field String mProducer = null;
@Field Integer documentiterator = 0;

// H�r letar vi efter parametrar fr�n Adaptern (metdata tabellen)
this.binding.variables.each {
    switch(it.key) {
        case "producer": mProducer = it.value; break;
        case "std.case": mDefaultCase = it.value; break;
        case "archiveOriginalXml": mStoreOriginalCaseXML = it.value.toBoolean(); break;
        case "debug": mDebug = it.value.toBoolean(); break;
    }
}


// Read input parameters
def Path targetPath = Paths.get(mTargetDirName);

// Un-zip and also find the files sip.xml and metadata file
FileUtil.unzip(mInputStream, targetPath, true);

// Throws IngestException if sip.xml can't be found
try
{
    mSipFile = FgsUtil.getSipXmlPath(targetPath);
    //println "H�r �r: ${mSipFile}"
}
catch (IngestException e)
{
    if (mDebug) {println e.getMessage(); e.printStackTrace()}
    try
    {
        mProducerSystem = FgsUtil.getProducerSystemFromSip(mSipFile);
        e.setProducer(mProducerSystem.getProducer());
        e.setSystem(mProducerSystem.getSystem());
        e.setObjectType(mDefaultCase);
    }
    catch (Exception e2)
    {
        // catch quietly
    }
    throw e;
}

// Throw IngestException if we can't find a valid submission agreement.
try
{
    mProducerSystem = FgsUtil.getProducerSystemFromSip(mSipFile);
    //println "H�r �r procucer ${mProducer} h�r �r system ${mProducerSystem}"
    // Vi s�tter en egen producer, vi skriver allts� �ver det som kom ifr�n FGS:en
    mProducerSystem.mProducer = "Samh�llsbyggnadsn�mnden"
    mProducerSystem.mSystem = "ByggR"

    //mProducerSystem.setProducer(mProducer)
    //println "H�r �r systemet ${mProducer}"
    //mProducerSystem.setSystem("ByggR")

    if (mDebug) {println "Found producer '${mProducerSystem.getProducer()}' and system '${mProducerSystem.getSystem()}'"}
    if (!mIsCli) {
        // H�r testar vi att inl�mningskontraktet finns f�r de angivna producer/system/�rende-typ
        SubmissionAgreementManager saManager = new SubmissionAgreementManager();
        saManager.getSubmissionAgreement(mProducerSystem.getProducer(), mProducerSystem.getSystem(), mDefaultCase);
    }
}
catch (AIPConfigurationNotFoundException e)
{
    if (mDebug) {println e.getMessage(); e.printStackTrace()}
    if (e.isProducerMissing() || e.isSystemMissing() || e.isSipTypeMissing())
    {
        String msg = MetaDataError.SA_MISSING.getMessage();
        IngestException ie = new IngestException(msg);
        ie.setProducer(mProducerSystem.getProducer());
        ie.setSystem(mProducerSystem.getSystem());
        ie.setObjectType(mDefaultCase);
        throw ie;
    }
    else
    {
        String msg = "Error occured when construcing error message regarding " +
                "submission agreement. Reason: " + e.getMessage();
        IngestException ie = new IngestException(msg);
        ie.setProducer(mProducerSystem.getProducer());
        ie.setSystem(mProducerSystem.getSystem());
        ie.setObjectType(mDefaultCase);
        throw ie;
    }
}
catch (Exception e)
{
    if (mDebug) {println e.getMessage(); e.printStackTrace()}
    String msg = "Failed to lookup submission agreement. Reason: " + e.getMessage();
    IngestException ie = new IngestException(msg);
    ie.setProducer(mProducerSystem.getProducer());
    ie.setSystem(mProducerSystem.getSystem());
    ie.setObjectType(mDefaultCase);
    throw ie;
}

// Throws IngestException if metadata file can't be found
try
{
    // Vi letar efter en fil efter ett angivet regex-uttryck
    mCaseFile = FgsUtil.getMetadataFile(targetPath, "(?i)arendehantering\\.xml");
    
    // H�r letar vi efter en .xml fil
    //mCaseFile = FgsUtil.getMetadataFile(targetPath, ".*.xml");
}
catch(Exception e)
{
    if (mDebug) {println e.getMessage(); e.printStackTrace()}
    String msg = "Metadata file not found. Reason: " + e.getMessage();
    IngestException ie = new IngestException(msg);
    ie.setProducer(mProducerSystem.getProducer());
    ie.setSystem(mProducerSystem.getSystem());
    ie.setObjectType(mDefaultCase);
    throw ie;
}

/*
 * Example on how to validate XML agains schema when the XML names one
 */
 

try {
    XMLUtil.validateXmlAgainstXsds(mCaseFile, 
        /*
         * Point to directory with schemas in 
         * <iipax>/extensions/plugin/scripts/fgs/xsd/<directory>
         * like <iipax>/extensions/plugin/scripts/fgs/xsd/fgsarende1.0
         */
        FgsUtil.getXSDs("fgsarende1.0"), 
        /*
         * Point to directory where related schemas can be found. Can be the same directory
         * as above
         */
         "fgsarende1.0"
  );


} catch (Exception e) {
    if (mDebug) {println e.getMessage(); e.printStackTrace()}
    String msg = "Validation error of '${mCaseFile.toString()}': " + e.getMessage();
    IngestException ie = new IngestException(msg);
    ie.setProducer(mProducerSystem.getProducer());
    ie.setSystem(mProducerSystem.getSystem());
    ie.setObjectType(mDefaultCase);
    throw ie;
}


/*
 * Example on how to validate XML agains a specific schema even if the XML does not specify a schema
 */


try {
    SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
    Schema schema = schemaFactory.newSchema(
        new File(BaseConfiguration.getPluginPath() + "scripts/fgs/xsd/fgsarende1.0/Arendehantering.xsd"));
    Validator validator = schema.newValidator();
    validator.validate(new StreamSource(mCaseFile.toFile()));
} catch (Exception e) {
    if (mDebug) {println e.getMessage(); e.printStackTrace()}
    String msg = "Validation error of '${mCaseFile.toString()}': " + e.getMessage();
    IngestException ie = new IngestException(msg);
    ie.setProducer(mProducerSystem.getProducer());
    ie.setSystem(mProducerSystem.getSystem());
    ie.setObjectType(mDefaultCase);
    throw ie;
}


// Validate the FGS package (XML against XSD and file references)
try
{
    //mFileToHash = FgsUtil.validate(mSipFile, mCaseFile);
    mFileToHash = FgsUtil.validate(
            /*
             * S�kv�gen till sip.xml
             */
            mSipFile,
            /*
             * S�kv�gen till metadatafilen
             */
            mCaseFile,
            /*
             * Regex f�r hur bilagor identifieras i metadatafilen
             */
            "//*[local-name()='Bilaga']",
            /*
             * Vad attributet heter p� elementet som inneh�ller bilagan
             */
            "Lank",
            /*
             * Lista p� filer som finns med i leveransen med som antingen inte finns med i sip.xml eller �rendefilen.
             * Det kan t.ex. var schemafiler.
             */
            [],
            /*
             * true - Filer m�ste ha r�tt versaler/gemener enligt sip.xml
             * false - Filer beh�ver inte ha r�tt versaler/gemener enligt sip.xml
             */
            false,
            /*
             * true - Kontrollera om filer har giltiga tecken enligt FGS
             * false - Kontrollera ej om filer har giltiga tecken enligt FGS
             */
            false,
            /*
             * true - Kontrollsummor i sip.xml valideras emot filer
             * false - Kontrollsummor i sip.xml valideras ej emot filer
             */
            false,
            /*
             * Anger vilken version validering enligt FGS Paketstruktur, allts� sip.xml g�r emot.
             * <iipax>/extensions/plugin/scripts/fgs/xsd/<version>, t.ex.
             * <iipax>/extensions/plugin/scripts/fgs/xsd/fgspkt1.0
             * 
             * M�jliga versioner idag �r fgspkt1.0, fgspkt1.1 och fgspkt1.2
             * S�tt "no_validation" om ingen validering ska g�ras.
             */
           "no_validation",
            /*
             * Anger vilken version validering av �rende XMLen g�r emot.
             * Noter att XMLen m�ste ange ett schema och schemafilerna ska hittas i
             * <iipax>/extensions/plugin/scripts/fgs/xsd/<version>, t.ex.
             * <iipax>/extensions/plugin/scripts/fgs/xsd/fgsarende1.0
             * 
             * S�tt "no_validation" om ingen validering ska g�ras.
             */
            "no_validation"
            ) 
}

catch (IngestException e)
{
    if (mDebug) {println e.getMessage(); e.printStackTrace()}
    try
    {
        e.setProducer(mProducerSystem.getProducer());
        e.setSystem(mProducerSystem.getSystem());
        e.setObjectType(mDefaultCase);
    }
    catch (Exception e2)
    {
        // catch quietly
    }
    throw e;
}


try
{
    createMassingestPackage();
}
catch (IngestException e)
{
    if (mDebug) {println e.getMessage(); e.printStackTrace()}
    e.setProducer(mProducerSystem.getProducer());
    e.setSystem(mProducerSystem.getSystem());
    e.setObjectType(mDefaultCase);
    throw e;
}

if (mDebug) {println "FGS package successfully transformed"}
return mProducerSystem;

/**
 * Goes through XML file with all cases and create Archive.xml
 * files while also moving files to their corresponding case in the package
 * @throws Exception
 */
public void createMassingestPackage() throws IngestException
{
    mDbFactory = DocumentBuilderFactory.newInstance();
    mDocBuilder  = mDbFactory.newDocumentBuilder();

    // Read xml file
    File fXmlFile = mCaseFile.toFile();
    Document doc = mDocBuilder.parse(fXmlFile);

    //optional, but recommended
    //read this - http://stackoverflow.com/questions/13786607/normalization-in-dom-parsing-with-java-how-does-it-work
    doc.getDocumentElement().normalize();


    // Loop through each case
    List<Node> caseNodes = XMLUtil.getXPathNodeList(doc,
            "/Leveransobjekt/ArkivobjektListaArenden/ArkivobjektArende");
    for (Node caseNode : caseNodes)
    {
        Element caseElem = XMLUtil.getElementFromNode(caseNode);
        if (caseElem != null)
        {
            // At the case node element

            // Create case xml container object
            ArchiveXml archiveXml = FgsUtil.createArchiveXML(mProducerSystem.getSystem(), mProducerSystem.getProducer(), false, mDefaultAttributes);
            archiveXml.setObjectType(mDefaultCase);

            // Location on disk to create case in
            String displayName = XMLUtil.getXPathNodeValue(caseElem, "ArkivobjektID").replaceAll("[/ ]", "_");
            String archiveXmlDir = mTargetDirName + "/" + displayName + "/";

            // Location on disk to create the Archive.xml in
            String archiveXmlPath = archiveXmlDir + "Archive.xml";

            // Location to move files belong to the case
            String docDir = archiveXmlDir + "doc";

            // Parse case (AIP)
            parseCaseNode(caseElem, archiveXml, docDir);


            // Append default attributes for the case after all other attributes and child objects has been added from parsing the XML
            archiveXml.addDefaultAttributes();

            // Extract all case XML data and store as a separate file
            if (mStoreOriginalCaseXML)
            {
                String originalCaseXmlFileName = "original.xml";
                String originalCaseXmlPath = docDir + "/" + originalCaseXmlFileName;
                FgsUtil.createXMLFileFromElement(caseElem, originalCaseXmlPath);
                archiveXml.createDocument();
                archiveXml.setObjectType("xml_document");
                archiveXml.setDisplayName("originaldata");

                Attribute styleSheetAttr = new Attribute("stylesheet", "generell visningsmall");
                Attribute sekretess = new Attribute("secrecy", "0")
                Attribute personuppgifter = new Attribute("pul_personal_secrecy", "0");
                Attribute other_secrecy = new Attribute("other_secrecy", "0");
                archiveXml.createFile(originalCaseXmlFileName, [styleSheetAttr, personuppgifter, other_secrecy]);
                archiveXml.finishElement();
            }


            // Write archive.xml to disc
            new File(archiveXmlPath).getParentFile().mkdirs();
            FgsUtil.transform(archiveXml.mDoc, new File(archiveXmlPath));
        }
    }

    // Clean up after parsing the case file. Remove sip.xml and case file
    File caseFile = mCaseFile.toFile();
    FgsUtil.deleteFile(caseFile);
    if (FgsUtil.isEmpty(caseFile.getParentFile()))
    {
        FgsUtil.deleteFile(caseFile.getParentFile());
    }
    FgsUtil.deleteFile(mSipFile.toFile());
}



    private void parseCaseNode(Element caseElem, ArchiveXml archiveXml, String docDir) throws Exception
    {

        // Display name
        String displayName = XMLUtil.getXPathNodeValue(caseElem, "ArkivobjektID");
        String arendemening = XMLUtil.getXPathNodeValue(caseElem, "Arendemening").trim()
        archiveXml.setDisplayName("${displayName}. ${arendemening.trim()}");

        println "-- �rendet ${displayName}"

        // Parse AIP attributes
        Attribute attribute = createAttribute(caseElem, "diarienummer", "ArkivobjektID")
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(caseElem, "motpart_diarienummer", "ExtraID")
        archiveXml.appendAttribute(attribute);
        
        String arende_typ = XMLUtil.getXPathNodeValue(caseElem, "ArendeTyp").trim()
        attribute = new Attribute("arendetyp", arende_typ)
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(caseElem, "avslutat_datum", "Avslutat", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        String beskrivning = XMLUtil.getXPathNodeValue(caseElem, "Beskrivning").trim()
        attribute = new Attribute("beskrivning", beskrivning)
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(caseElem, "registrerat_datum", "Skapad", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(caseElem, "arendestart_datum", "Upprattad", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        //OBS! FEL I XML fr�n BYGGR
        attribute = createAttribute(caseElem, "riktning", "StatusArande")
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(caseElem, "inkom_datum", "Inkommen", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(caseElem, "expedierad_datum", "Expedierad", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        attribute = new Attribute("arendemening", arendemening)
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(caseElem, "anteckningar", "Notering")
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(caseElem, "beslutsdatum", "Beslutat", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        List<Node> fastigheter = XMLUtil.getXPathNodeList(caseElem, "EgnaElement/EgetElement[@Namn='Fastighetsbeteckning']/Varde");
        for (Node fastighet : fastigheter)
        {
            String varde = fastighet.getTextContent()
            println "${varde}"
            attribute = new Attribute("fastighetsbeteckning", varde);
            archiveXml.appendAttribute(attribute, true);

        }

        List<Node> fastighetsnummer = XMLUtil.getXPathNodeList(caseElem, "EgnaElement/EgetElement[@Namn='Fastighetsnummer(Fnr)']/Varde");
        for (Node object : fastighetsnummer)
        {
            String varde = object.getTextContent()
            println "${varde}"
            attribute = new Attribute("fastighetsnummer", varde);
            archiveXml.appendAttribute(attribute, true);

        }

          List<Node> adresser = XMLUtil.getXPathNodeList(caseElem, "EgnaElement/EgetElement[@Namn='Belagenhetsadress']/Varde");
        for (Node adress : adresser)
        {
            String varde = adress.getTextContent()
            println "${varde}"
            attribute = new Attribute("adress", varde);
            archiveXml.appendAttribute(attribute, true);

        }

        //REGEX f�r att leta adresser bland Winb�r-materialet.
        String testing = XMLUtil.getXPathNodeValue(caseElem, "Notering")
        //Plattar ut str�ngen och tar bort \n
        testing = testing.replace("\n", "").replace("\r", "");

        Pattern regexpattern = Pattern.compile(".*Adress:\\s(.*?),\\s(.*?)-.*");
        Matcher m = regexpattern.matcher(testing)
        //ANV�ND FIND! .*Adress:\s(.*?)(,)\s(.*?)-.* Pattern.compile(".*Adress:\\s(.*),\\s(.*?)-.*");
        if (m.find( )) {
            varde = "${m.group(1)}, ${m.group(2)}"
            if (varde.trim() != ',') 
            {
                attribute = new Attribute("adress", varde.trim());
                archiveXml.appendAttribute(attribute, true);
            }
        }
         
        // OBS! Loopa igenom Instans + beslutsnummer 
        attribute = createAttribute(caseElem, "beslutsinstans", "EgnaElement/EgetElement[@Namn='BeslutInstans']/Varde")
        archiveXml.appendAttribute(attribute)

        attribute = createAttribute(caseElem, "beslutsnummer", "EgnaElement/EgetElement[@Namn='BeslutNr']/Varde")
        archiveXml.appendAttribute(attribute)
       

        attribute = new Attribute("secrecy", "0")
        archiveXml.appendAttribute(attribute);
        
        //Skyddar vissa �rendetyper fr�n publicering p� webben.
        if (displayName.startsWith('ADM')||displayName.startsWith('BSAM')||displayName.startsWith('D')||displayName.startsWith('DIV')||displayName.startsWith('EXP')||displayName.startsWith('NONE')||displayName.startsWith('PERS')||displayName.startsWith('TKS')) {
            attribute = new Attribute("other_secrecy", "20")
        archiveXml.appendAttribute(attribute);
        }
        else {
        attribute = new Attribute("other_secrecy", "0")
        archiveXml.appendAttribute(attribute);
        }

        attribute = new Attribute("pul_personal_secrecy", "0")
        archiveXml.appendAttribute(attribute);

        


        // If the case can contain files directly on the case, then loop through files here

        // Loop through documents and their files

        List<Node> documentNodes = XMLUtil.getXPathNodeList(caseElem,
            "ArkivobjektListaHandlingar/ArkivobjektHandling");
           documentiterator = 0
        for (Node documentNode : documentNodes)
        {
            
            Element documentElem = XMLUtil.getElementFromNode(documentNode);
            if (documentElem != null)
            {
                documentiterator += 1
                parseDocumentNode(documentElem, archiveXml, docDir);
            }
        }
    }

    private void parseDocumentNode(Element documentElem, ArchiveXml archiveXml, String docDir) throws Exception
    {
        Attribute attribute = null;
        
        //HANDLINGSNIV�

        archiveXml.createDocument();
        archiveXml.setObjectType(mDefaultDocument);

        
        //println documentiterator
        // Display name
        String arkivobjektID = XMLUtil.getXPathNodeValue(documentElem, "ArkivobjektID");
        String handlingstyp = XMLUtil.getXPathNodeValue(documentElem, "Handlingstyp");
        
        //archiveXml.setDisplayName(arkivobjektID + " TEST");
        //archiveXml.setDisplayName("TEST1 ${arkivobjektID} TEST2");
        archiveXml.setDisplayName("${documentiterator}. ${handlingstyp}");
        //archiveXml.setDisplayName("Samma j�mnt (dumt)");

        archiveXml.appendAttribute(new Attribute("handling_typ", handlingstyp));

        attribute = createDateAttribute(documentElem, "inkom_datum", "Inkommen", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(documentElem, "expedierad_datum", "Expedierad", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(documentElem, "anteckningar", "Beskrivning")
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(documentElem, "riktning", "StatusHandling")
        archiveXml.appendAttribute(attribute);

        String testValue = XMLUtil.getXPathNodeValue(documentElem, "Restriktion[@Typ='Sekretess']");
        if (testValue?.trim())
        {
            archiveXml.appendAttribute(new Attribute("secrecy", "10"));
        }
        else {   
            archiveXml.appendAttribute(new Attribute("secrecy", "0"));
        }

        archiveXml.appendAttribute(new Attribute("pul_personal_secrecy", "0"));
        
        //Lista med handlingstyper som inte ska publiceras p� webben enligt Samh�llsbyggnad (d�refter motsvarande lista som uppercase)
        def handlingstypslistaskyddad = ["RIVNINGSANM�LAN","RIVNINGSPLAN","SAMORDNINGSANSVARIG","SAMORDNINGSPLAN","Samr�dshandlingar","Sanktionsavgift","SKRIVELSE","SKRIVELSE ADK","SKRIVELSE KF/KS","SKRIVELSE LSN","SKRIVELSE SBK","SKYDDSRUMBESKED","Skyddsrumsbesked","SKYDDSRUMSBESKED","SPR�NGNINGSARBETE","STATISKA BER�KNINGAR","STOMRITNING","Strandskydd","Svar externgranskning","TAKLAGSRITNING","Tekniskt snitt","Telia","Tj�nsteskrivelse","Tomtplanering","T�THETSPROVN/VENT","Underlagshandl konstruktion","Underlagshandl plan","Underlagshandl r�r","Underlagshandl ventilation","Underr�ttelse revidering","Under�ttelse samf�lld mark","Uppdrag","UPPST�LLNINGSRITNING","UTDRAG ADRESSKARTAN","Utredningar/ Underlag","Utskick komplettering","UTSTAKNING","UV�RDESBER�KNING","V�GVERKETS YTTRANDE","V�RMEEFFEKTBEHOVSBER�KNING","YRKESINSPEKT YTTR VENT","YRKESINSPEKTIONENS YTTR.","YTTR.BRANDF�RSVARET","YTTR.FR�N GRANNE (AR)","YTTR.FR�N KLK MARK O EXP","YTTR.SPR�NG�MNESINSP.","Yttrande","YTTRANDE","Yttrande (Markavdelningen)","Yttrande (�vriga)","Yttrande Bor�s Energi & Milj�","Yttrande fr�n SBK","YTTRANDE MILJ�SKYDDSKONTORET","YTTRANDE SBK","Yttrande �vrigt","Anm�lan","Annan handling","Anslagen inbjudan","Anslagen under�ttelse","Anslaget protokollsutdrag SBN","Ans�kan","Ans�kan om planbesked","Arbetstagarintyg","Arrendeavtal","Atomhandling","Atomutskick","Beg�ran om komplettering","Beg�ran om komplettering  f�r slutbesked","Beg�ran om komplettering f�r starbesked","Bilaga remissvar","Checklista f�r kartuppdrag","Debiteringsunderlag","Delgivning","Delgivningskvitto","E-post","Etiketter","Fullmakt","F�rfr�gningsunderlag","Godk�nnande","Grannemedgivande","Inbjudan till samr�d","Konsultavtal","Kontrakt","Laga kraftbevis","Meddelande","Minnesanteckningar","Planbesked","Planbeskrivning","Planbest�mmelser","Plankarta","Plankostnadsavtal","Planprogram","Presentation","Programsamr�dsredog�relse","P�minnelse beg�ran om komplettering","Remiss","Remissvar","Sammanst�llning","Samr�dsredog�relse","Samr�dsyttrande","Skrivelse","Skrivelse fr�n fastighets�gare","Skrivelse fr�n fastighets�gare/utf�rare","Skrivelse fr�n granne","Skrivelse fr�n kontrollansvarig","Skrivelse fr�n s�kande/byggherre","Skrivelse fr�n utf�rare","Skrivelse till byggnadsn�mnden","Skrivelse till fastighets�gare","Skrivelse till fastighets�gare/utf�rare","Skrivelse till handl�ggare","Skrivelse till s�kande/byggherre","Skrivelse, ans�kan om slutbesked","Skrivelse, ans�kan om startbesked","S�ndlista","Typen saknades vid konverteringen","Underr�ttelse","Underr�ttelse inf�r antagande","Underr�ttelse om granskning","Under�ttelse efter antagande","Uppdragsbeskrivning","Utredning","Yttrande","Yttrande (granne)","�tg�rdsplan","�rendebekr�ftelse","�vrigt","�vrigt","�VRIGT","��",];
		def handlingstypslistaskyddadUppercase = handlingstypslistaskyddad.collect{ it.toUpperCase() }
		
        //Lista med handlingstyper som kan publiceras enligt Samh�llsbyggnad (d�refter motsvarande lista som uppercase)
        def handlingstyplistapublik = ["R�RARBETE","R�rritning","SEKTIONS RITNING","SEKTIONS RITNING","Sit.plan (av enkel b-lovkarta)","Sit.plan (fr blov-karta)","Sit.plan (fr nybyggnadskarta)","SITP,PLAN.SEKTION,FASAD","SITPL.PLAN.SEKT.FASAD","SITUATIONSPLAN","SITUATIONSPLAN","SITUATIONSPLAN","SITUATIONSPLAN BRANDF.VARA","Situationsplan VA","SITUATIONSPLAN-VA","SKORSTENSFEJARM�STARINTYG","SKORSTENSRITNING/BESKRIVNING","SKYLTRITNING","Slutanm�lan","Sotarintyg","TEKNISK BESKRIVNING","TEKNISK BESKRIVNING","TEKNISK BESKRIVNING HISS","TEKNISK BESKRIVNING VA","TEKNISK BESKRIVNING-VA","Utl�tande akustik","VA- OCH V�RMERITNINGAR","VA-HANDLINGAR","Vatten och avlopp","VATTEN- OCH AVLOPPSRITNINGAR","Ventilationsinjustering","Ventilationsinjustering","VENTILATIONSRITNINGAR","VERKSAMHETSBESKRIVNING","VS ritning","VVS ritning","V�RMERITNINGAR","Yttre VA","Anl�ggarintyg brandlarm","Anm�lan kontrollansvarig","Arbetsmilj�plan","Avfallshantering","Avvecklingsplan","Behovsbed�mning","Bergtekniskt utredning","Ber�kningar","Besiktningsprotokoll","Beslut","Beslut fr�n kommunstyrelsen","Besv�rsh�nvisning","Bilaga","Bilaga kontrollplan","Brand-PM","Brandritning","Brandskyddsbeskrivning","Brandskyddsdokumentation","Brandtekniskt utl�tande","Brev till l�nsstyrelsen","Bullerutredning","Bygglovkarta","Byggsanktionsavgift","Certifikat","Dagvattenhantering","Dagvattenutredning","Deponikvitto","Detaljritning","Dimensioneringskontroll","Egenkontroll","Elritning","Els�kerhetsintyg","Energiber�kning","Energiber�kning (verifierad)","Energideklaration","Externgranskningssvar","Externgranskningssvar (BEM, avfall)","Externgranskningssvar (BEM, ledningsn�t)","Externgranskningssvar (FOF)","Externgranskningssvar (Kulturf�rv)","Externgranskningssvar (Lantm�teriet)","Externgranskningssvar (Mark)","Externgranskningssvar (Milj�f�rv)","Externgranskningssvar (SPA)","Externgranskningssvar (S�RF)","Externgranskningssvar (Tekniska f�rv)","Fasad/sektion","Fasadritning","Fastighetsf�rteckning","Fotografi","Fotomontage","Fuktm�tning","Fuktskyddsbeskrivning","Funktionsbeskrivning","F�rdigst�llandeskydd","F�rgs�ttningsf�rslag","F�ljebrev","Geoteknisk utredning","Granskningsutl�tande","Granskningsyttrande","Grundritning","Grundsektion","Illustration","Intyg","Karta","Konstruktionsber�kning","Konstruktionsdokumentation","Konstruktionsritning","Kontrollplan (f�rslag)","Kontrollplan (verifierad)","Kung�relse Bor�s Tidning","Kung�relse digital anslagstavla","Luftfl�desprotokoll","Luftt�thetsm�tning","Luftutredning","L�genhetsf�rteckning","L�geskontroll","Markplaneringsritning","Marksektionsritning","Milj�besiktning","Milj�inventering","Milj�teknisk markutredning","Monteringsanvisning","M�tningsuppdrag","Naturinventering","Nybyggnadskarta","OVK-protokoll","Perspektivskiss","Plan/fasad","Plan/fasad/sektion","Plan/sektion","Planritning","Prestandadeklaration","Produktinformation","Projektbeskrivning","Protokoll","Protokoll fr�n platsbes�k","Protokoll �ver arbetsplatsbes�k","Protokoll �ver slutsamr�d","Protokoll �ver tekniskt samr�d","Provtryckning VVS","Provtryckningsprotokoll","Redovisning parkering","Relationshandling","Relationsritning","Riskinventering/riskanalys","Riskutredning","Ritning befintlig byggnad","Ritningsf�rteckning","Rivningsinventering","Rivningsplan","Rivningsplan (verifierad)","R�rritning","Sakkunnigintyg","Sektionsritning","Situationsplan","Situationsplan/plan/fasad/sektion","Skiss","Sotarintyg","Strandskyddsdispens","S�ker vatteninstallation","Teknisk beskrivning","Tidplan","Tilldelningsbeslut","Tillg�nglighetsintyg","Tj�nsteskrivelse","Trafikutredning","Typgodk�nnande","Utf�randekontroll brand","Utl�tande","Utl�tande kontrollansvarig","Utstakning","U-v�rdesber�kning","VA-anvisning","VA-ritning","VA-situationsplan","Ventilationsritning","Verksamhetsbeskrivning","Vibrationsutredning","Visualisering","VS-ritning","V�trumsintyg","V�rmeritning","Yttrande (Fortifikationsverket)","Yttrande (FritidOFolkh�lsa)","Yttrande (F�rsvarsmakten)","Yttrande (Kulturf�rvaltningen)","Yttrande (Luftfartsverket)","Yttrande (L�nsstyrelsen)","Yttrande (MEX)","Yttrande (Milj�f�rvaltningen)","Yttrande (MSB)","Yttrande (Statensj�rnv�gar)","Yttrande (S�RF)","Yttrande (Trafikverket)","Yttrande (Vattenfall)","Yttrande remissinstans","Yttrande(Statens Haverikommission)","�terkallande ","�ndrings-PM","�verklagande","�verklagande: Beslut mm","�verklagande: R�ttidspr�vning mm","�verklagande: Sak�garskrivelse"]
        def handlingstyplistapublikUppercase = handlingstyplistapublik.collect{ it.toUpperCase() }
        

        //Kontroll om handlingen ska skyddas eller inte (alltid uppercase). Gjord som else if om man vill ha tre olika alternativ...
        if (handlingstypslistaskyddadUppercase.contains(handlingstyp.trim().toUpperCase()))
        {
            archiveXml.appendAttribute(new Attribute("other_secrecy", "10"));
        }
        else if (handlingstyplistapublikUppercase.contains(handlingstyp.trim().toUpperCase()))
        {
            archiveXml.appendAttribute(new Attribute("other_secrecy", "0"));
        }
        else {
            archiveXml.appendAttribute(new Attribute("other_secrecy", "10"));
        }
        
        // Loop through files
        List<Node> fileNodes = XMLUtil.getXPathNodeList(documentElem, "Bilaga");
        for (Node fileNode : fileNodes)
        {
            Element fileElem = XMLUtil.getElementFromNode(fileNode);
            if (fileElem != null)
            {
                parseFileNode(fileElem, archiveXml, docDir);
            }
        }

        archiveXml.finishElement();
    }

    private void parseFileNode(Element fileElem, ArchiveXml archiveXml, String docDir) throws Exception
    {
        // Parse file object
        String fileLink = XMLUtil.getXPathNodeValue(fileElem, "@Lank").replaceAll("\\\\","/");


        // To be able to make a file comparison of the found file items.
        // We need to remove any leading slashes of the file path.
        if (fileLink.startsWith("/"))
        {
            fileLink = fileLink.substring(1);
        }

        // mFileToHash �r en lista av filerna i sip.xml
        FileInfo fileInfo = mFileToHash.get(fileLink);

        // Intention: We should always be able to rely on the fileInfo.getPath returning
        // the correct path here
        String originalAbsFilePath = mTargetDirName + "/" + fileInfo.getPath();
        
        // Anv�nd l�nken till filen fr�n �rende XML:en
        //String originalAbsFilePath = mTargetDirName + "/" + fileLink;

        // Anv�nd l�nken till filen fr�n �rende XML:en och leta efter filen i en annan mapp
        //String originalAbsFilePath = C:/min_egen_mapp/filer + "/" + fileLink;

        File origFile = new File(originalAbsFilePath);

        String lta_file_digest = fileInfo.getType() + ":" + fileInfo.getChecksum();
        Attribute checksumAttr = new Attribute("lta_file_digest", lta_file_digest);

        archiveXml.createFile(origFile.getName(), [checksumAttr]);

        // Ta inte med checksumma
        //archiveXml.createFile(origFile.getName(), []);

        String newAbsFilePath = docDir + "/" + origFile.getName();
        File newFile = new File(newAbsFilePath);

        // Move origFile to correct folder
        // ! Viktigt, filen som ska arkvieras flyttas och f�rsvinner fr�n originalmappen
        FileUtil.moveFile(origFile.toPath(), newFile.toPath());

        // Alternativt, copiera filen till doc-mappen
        // TODO: L�gg till exempel

        if (origFile.getParentFile().list().length == 0)
        {
            origFile.getParentFile().delete();
        }
    }

private Attribute createAttribute(Node node,
        String attributeType,
        String xPath)
        throws XPathException, ParseException
{
    return createAttribute(node, attributeType, xPath, null, false);
}

private Attribute createAttribute(Node node,
    String attributeType,
    String xPath,
    String defaultValue,
    boolean allowEmptyValue)
    throws XPathException, ParseException
{
    String nodeValue = XMLUtil.getXPathNodeValue(node, xPath);
    if (nodeValue == null && defaultValue != null)
    {
        nodeValue = defaultValue;
    }

    Attribute attr = new Attribute(attributeType, nodeValue, allowEmptyValue);
    return attr;
}

private Attribute createDateAttribute(Node node,
    String attributeType,
    String xPath,
    List<SimpleDateFormat> fromSimpleDateFormats)
    throws XPathException, ParseException
{
    return createDateAttribute(node, attributeType, xPath, null, false, fromSimpleDateFormats);
}

private Attribute createDateAttribute(Node node,
        String attributeType,
        String xPath,
        String defaultValue,
        boolean allowEmptyValue,
        List<SimpleDateFormat> fromSimpleDateFormats)
        throws XPathException, ParseException
{
    String nodeValue = XMLUtil.getXPathNodeValue(node, xPath);
    if (nodeValue == null && defaultValue != null)
    {
        nodeValue = defaultValue;
    }

    nodeValue = FgsUtil.formatDate(nodeValue, fromSimpleDateFormats);

    Attribute attr = new Attribute(attributeType, nodeValue, allowEmptyValue);
    return attr;
}
