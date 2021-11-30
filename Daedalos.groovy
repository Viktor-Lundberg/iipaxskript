/*
 * Encoding ISO-8859-1
 * Make sure following 3 characters look ok: åäö
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
@Field BufferedInputStream mInputStream


@Field Boolean mDebug = false
@Field Boolean mIsCli = false


if (args != null && args.size() != 0) {
    println "Running in command line mode"
    // Will not get here if called by iipax, only when called from command line with the given example
    // Call from '<iipax>\groovy\bin' with 'groovy ../../extensions/plugin/scripts/fgs/groovy/TransformFgsToCaseUtbildning.groovy cli'

    // Set the parameters targetDirName and inputStream which are oterwise set by iipax
    // Where to store the output of the script
    mTargetDirName = "C:\\temp\\fgs-test"
    // Where to find the .zip to process
    mInputStream = new BufferedInputStream(new FileInputStream("C:\\temp\\2019-000829.zip"))

    mDebug = true
    mIsCli = true
}
else {
    // Input parameters [targetDirName, inputStream]
    mTargetDirName = targetDirName
    mInputStream = inputStream
}

if (mDebug) {println "Starting FGS transformation"}


@Field Path filepath 

@Field ProducerSystem mProducerSystem;

@Field DocumentBuilderFactory mDbFactory;

@Field DocumentBuilder mDocBuilder;

@Field Path mCaseFile;

@Field Path mSipFile;

@Field String mDefaultCase = "Daedalos_arande";

@Field String mDefaultDocument = "Daedalos_handling";

@Field String mDefaultCaseType = "-";

@Field HashMap<String, FileInfo> mFileToHash;

@Field SimpleDateFormat sSdfFrom = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

@Field SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");

@Field SimpleDateFormat sSdfFromWithMillis =
        new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.S");

@Field List<Attribute> mDefaultAttributes = new ArrayList<Attribute>();


//Attribute a1 = new Attribute("case_type", mDefaultCaseType);
//mDefaultAttributes.add(a1);

@Field boolean mStoreOriginalCaseXML = true;

@Field String mProducer = null;

// Här letar vi efter parametrar från Adaptern (metdata tabellen)
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

println mInputStream

// Un-zip and also find the files sip.xml and metadata file
FileUtil.unzip(mInputStream, targetPath, true);

// Går igenom target-katalogen och identifierar katalognamn och lägger i workingdir
dh = new File("${targetPath}")
dh.eachFile {
    workingDir = it
}

//Lägger workingDir i casePath
def Path casePath = Paths.get("${workingDir}")

//Skapar variabel för var skriptet ska hitta filerna
filepath = casePath


// Throws IngestException if sip.xml can't be found
try
{
    mSipFile = FgsUtil.getSipXmlPath(casePath);
    
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

def sipXML = mSipFile

// Throw IngestException if we can't find a valid submission agreement.
try
{
    mProducerSystem = FgsUtil.getProducerSystemFromSip(mSipFile);
    // Vi sätter en egen producer, vi skriver alltså över det som kom ifrån FGS:en
    mProducerSystem.mProducer = "Södra Älvsborgs Räddningstjänstförbund"

    //mProducerSystem.setProducer(mProducer)
    //mProducerSystem.setSystem("vårast system")

    if (mDebug) {println "Found producer '${mProducerSystem.getProducer()}' and system '${mProducerSystem.getSystem()}'"}
    if (!mIsCli) {
        // Här testar vi att inlämningskontraktet finns för de angivna producer/system/ärende-typ
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
    mCaseFile = mSipFile

    File fXmlFile = mCaseFile.toFile();
    
    Document doc = mDocBuilder.parse(fXmlFile);
    


    //optional, but recommended
    //read this - http://stackoverflow.com/questions/13786607/normalization-in-dom-parsing-with-java-how-does-it-work
    doc.getDocumentElement().normalize();

    if (mDebug) {print doc.getDocumentElement().toString()}


    // Loop through each case
    List<Node> caseNodes = XMLUtil.getXPathNodeList(doc,
            "mets/dmdSec/mdWrap/xmlData/ARN");
            if (mDebug) {println caseNodes}
            ///Leveransobjekt/ArkivobjektListaArenden/ArkivobjektArende
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
            String displayName = XMLUtil.getXPathNodeValue(caseElem, "Diarienummer").replaceAll("[/ ]", "_");
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
                archiveXml.setDisplayName("original");

                Attribute styleSheetAttr = new Attribute("stylesheet", "generell visningsmall");

                archiveXml.createFile(originalCaseXmlFileName, [styleSheetAttr]);
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
        String diarienummer = XMLUtil.getXPathNodeValue(caseElem, "Diarienummer");
        String arendemening = XMLUtil.getXPathNodeValue(caseElem, "Arendemening").trim()
        //String displayName = "${diarienummer}, ${arendemening}"
        String displayName = "${diarienummer}"
        archiveXml.setDisplayName(displayName);

        if (mDebug) {println "-- Ärendet ${displayName}"}

        // Parse AIP attributes
        attribute = new Attribute("diarienummer", diarienummer)
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(caseElem, "diarieplanbeteckning", "Klass")
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(caseElem, "arendetyp_kod", "Arendekod")
        archiveXml.appendAttribute(attribute);

        attribute = new Attribute("arendemening", arendemening)
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(caseElem, "arendetyp", "Arendebenamning")
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(caseElem, "registrerat_datum", "Registreringsdatum", [sSdfFromWithMillis, sSdfFrom, yyyymmdd])
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(caseElem, "roll_handlaggare", "Ansvarig_handlaggare")
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(caseElem, "motpart", "Motpart")
        archiveXml.appendAttribute(attribute);

        attribute = createAttribute(caseElem, "motpart_diarienummer", "Extra_diarienummer_extern")
        archiveXml.appendAttribute(attribute);

        String secrecyValue = XMLUtil.getXPathNodeValue(caseElem, "Sekretess_OSL");
        if (secrecyValue?.trim() == "Nej")
        {
            archiveXml.appendAttribute(new Attribute("secrecy", "0"));
        }
        else {   
            archiveXml.appendAttribute(new Attribute("secrecy", "10"));
        }

        secrecyValue = XMLUtil.getXPathNodeValue(caseElem, "Sekretess_PUL");
        if (secrecyValue?.trim() == "Nej")
        {
            archiveXml.appendAttribute(new Attribute("pul_personal_secrecy", "0"));
        }
        else {   
            archiveXml.appendAttribute(new Attribute("pul_personal_secrecy", "10"));
        }
        
        archiveXml.appendAttribute(new Attribute("other_secrecy", "20"));

        //Går igenom Arnconnect för att hämta fastighetsbeteckningar, adresser och verksamheter
        List<Node> fastigheter = XMLUtil.getXPathNodeList(caseElem, "Arnconnects/Arnconnect");
        for (Node fastighet : fastigheter)
        {
            //Fastighetsbeteckning från FST-delen
            if  (XMLUtil.getXPathNodeValue(fastighet, "Typ") == "FST")
            {
            varde = XMLUtil.getXPathNodeValue(fastighet, "Fastighet")
            attribute = new Attribute("fastighetsbeteckning", varde);
            archiveXml.appendAttribute(attribute, true);
            }
            
            // Verksamhetsnamn och adress från VER-delen
            if  (XMLUtil.getXPathNodeValue(fastighet, "Typ") == "VER")
            {
            varde = XMLUtil.getXPathNodeValue(fastighet, "Benamning")
            attribute = new Attribute("objektsnamn", varde);
            archiveXml.appendAttribute(attribute, true);
            
            varde = XMLUtil.getXPathNodeValue(fastighet, "Adress")
            attribute = new Attribute("adress", varde);
            archiveXml.appendAttribute(attribute, true);
            
            }

        }
        
        /* DATUM??
        attribute = createDateAttribute(caseElem, "arendestart_datum", "Skapad", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);

        attribute = createDateAttribute(caseElem, "avslutat_datum", "Skapad", [sSdfFromWithMillis, sSdfFrom])
        archiveXml.appendAttribute(attribute);
        */
        
        // Kontrollerar så att det inte är ett P-ärende!
        String testValue = XMLUtil.getXPathNodeValue(caseElem, "Diarienummer");
        if (testValue?.trim()[-1] == "P")
        {
            String msg = "Ärende ${displayName} ska inte arkiveras!"
            println msg

            // Vi slänger ett fel till vårat valideringskvitto
            IngestException ie = new IngestException(msg);
            ie.setProducer(mProducerSystem.getProducer());
            ie.setSystem(mProducerSystem.getSystem());
            ie.setObjectType(mDefaultCase);
            throw ie;   

        }
        else {
            // Vi får hitta på något
            
        }


        // Loop through documents and their files
        List<Node> documentNodes = XMLUtil.getXPathNodeList(caseElem,
            "Arnhandlingar/Arnhandling");
            
        for (Node documentNode : documentNodes)
        {
            Element documentElem = XMLUtil.getElementFromNode(documentNode);
            if (documentElem != null)
            {
                parseDocumentNode(documentElem, archiveXml, docDir);
            }
        }
    }

    private void parseDocumentNode(Element documentElem, ArchiveXml archiveXml, String docDir) throws Exception
    {
        Attribute attribute = null;

        archiveXml.createDocument();
        archiveXml.setObjectType(mDefaultDocument);

        // Display name
        String lopnummer = XMLUtil.getXPathNodeValue(documentElem, "Lopnummer");
        String beskrivning = XMLUtil.getXPathNodeValue(documentElem, "Beskrivning").trim();
        String doklopnummer = XMLUtil.getXPathNodeValue(documentElem, "Doklopnummer");
        archiveXml.setDisplayName("${lopnummer}.${doklopnummer}. ${beskrivning}");

        // new Attribute(internt iipax attribut, den text vi vill sätta)
        archiveXml.appendAttribute(new Attribute("beskrivning", beskrivning));

        // Loop through files
        List<Node> fileNodes = XMLUtil.getXPathNodeList(documentElem, "Filename");
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

        String fileLink = XMLUtil.getXPathNodeValue(fileElem, ".");
        // To be able to make a file comparison of the found file items.
        // We need to remove any leading slashes of the file path.
        if (fileLink.startsWith("/"))
        {
            fileLink = fileLink.substring(1);
        }
        String originalAbsFilePath = "${filepath}/${fileLink}";
        File origFile = new File(originalAbsFilePath);
        
        // Ta inte med checksumma
        archiveXml.createFile(origFile.getName(), []);

        String newAbsFilePath = docDir + "/" + origFile.getName();
        File newFile = new File(newAbsFilePath);

        // Move origFile to correct folder
        // ! Viktigt, filen som ska arkvieras flyttas och försvinner från originalmappen
        FileUtil.moveFile(origFile.toPath(), newFile.toPath());


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
