import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;
 
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.core.SimpleAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.LongField;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.Term;
import org.apache.lucene.index.IndexWriterConfig.OpenMode;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
 
public class TextfileIndexer {
 
    public static void main(String[] args) {
        String indexPath = "E:\\sem-4\\thesis\\index";
        String docsPath = "E:\\sem-4\\thesis\\manningtxt";
        boolean create = true;
        createIndex(indexPath, docsPath, create);
    }
 
    public static boolean createIndex(String indexPath, String docsPath,
            boolean create) {
        final File docDir = new File(docsPath);
        Date start = new Date();
        try {
            System.out.println("Indexing to directory '" + indexPath + "'...");
 
            Directory dir = FSDirectory.open(new File(indexPath));
            Analyzer analyzer = new SimpleAnalyzer(Version.LUCENE_30);
            IndexWriterConfig iwc = new IndexWriterConfig(Version.LUCENE_30,analyzer);
            if (create) {
                iwc.setOpenMode(OpenMode.CREATE);
            } else {
                // update index
                iwc.setOpenMode(OpenMode.CREATE_OR_APPEND);
            }
            iwc.setRAMBufferSizeMB(256.0);
                                                // creating the index writer
            IndexWriter writer = null;
            try {
                writer = new IndexWriter(dir, iwc);
            } catch (IOException e) {
                if (!new File(indexPath).exists()) {
                    new File(indexPath).mkdir();
                    writer = new IndexWriter(dir, iwc);
                }
            }
 
            indexDocs(writer, docDir);
            // writer.forceMerge();
            writer.close();
            Date end = new Date();
            System.out.println(end.getTime() - start.getTime()
                    + " total milliseconds");
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
 
    private static void indexDocs(IndexWriter writer, File file)
            throws IOException {
        if (file.canRead()) {
            if (file.isDirectory()) {
                String[] files = file.list();
                if (files != null) {
                    for (int i = 0; i < files.length; i++) {
                        indexDocs(writer, new File(file, files[i]));
                    }
                }
            } else {
                FileInputStream fis = null;
                try {
                    fis = new FileInputStream(file);
                } catch (FileNotFoundException fnfe) {
                    fnfe.printStackTrace();
                }
                try {
                                                                              // creating the Document object to store in the index
                    Document doc = new Document();
                    doc.add(new StringField("path", file.getPath(),Field.Store.YES));
                    doc.add(new LongField("modified", file.lastModified(),Field.Store.NO));
                    doc.add(new TextField("contents", new BufferedReader(new InputStreamReader(fis, "UTF-8"))));
 
                    if (writer.getConfig().getOpenMode() == OpenMode.CREATE) {
                                                                                                 // for creating the index
                        System.out.println("adding " + file);
                        writer.addDocument(doc);
                    } else {
                                                                                               // for updating the index’s
                        System.out.println("updating " + file);
                        writer.updateDocument(new Term("path", file.getPath()),doc);
                    }
                } finally {
                    fis.close();
                    }
            }
        }
    }
}
