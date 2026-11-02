package com.example.textileMultiModalAgent.common.utils;

import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.DocumentParser;
import dev.langchain4j.data.document.parser.TextDocumentParser;
import dev.langchain4j.data.document.parser.apache.poi.ApachePoiDocumentParser;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.apache.poi.ss.usermodel.*;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

@Tag(name = "LangChain4JPOIUtils", description = "POI类，支持解析word和excel文件")
public class LangChain4JPOIUtils {

     // 支持的文件类型
    public enum FileType {
        WORD, EXCEL, PDF, PPT, TEXT, UNSUPPORTED
    }

     // 缓存池, 避免重复创建
    private static final Map<FileType, DocumentParser> parserMap = new HashMap<>();

    static {
        // 构造器里注册，永远拿不到执行时机，改为类初始化时一次性注册
        parserMap.put(FileType.WORD, new ApachePoiDocumentParser());
        parserMap.put(FileType.TEXT, new TextDocumentParser());
    }


    /**
     * 解析文档总入口，判断类型
     * @param inputStream 文件流
     * @param fileName 文件名
     * @return LangChain4j Document对象
     * @throws Exception
     */
    public static Document parse(InputStream inputStream, String fileName) throws Exception {

        FileType fileType = inferFileType(fileName);

        switch (fileType) {
            case WORD:
                return parseWord(inputStream, fileName);
            case EXCEL:
                return parseExcelToMarkdown(inputStream, fileName);
            case PDF:
                // 如果需要解析PDF，确保引入了 langchain4j-document-parser-apache-pdfbox
                return parseWithRegisteredParser(inputStream, fileName, fileType);
            case TEXT:
                // 纯文本可以直接使用内置解析器或自行读取
                return parseWithRegisteredParser(inputStream, fileName, fileType);
            default:
                throw new UnsupportedOperationException("Unsupported file type: " + fileName);
        }
    }


    /**
     * 推断文件类型
     */
    public static FileType inferFileType(String fileName) {
        if (fileName == null) return FileType.UNSUPPORTED;
        String lowerName = fileName.toLowerCase();
        if (lowerName.endsWith(".doc") || lowerName.endsWith(".docx")) {
            return FileType.WORD;
        } else if (lowerName.endsWith(".xls") || lowerName.endsWith(".xlsx")) {
            return FileType.EXCEL;
        } else if (lowerName.endsWith(".pdf")) {
            return FileType.PDF;
        } else if (lowerName.endsWith(".ppt") || lowerName.endsWith(".pptx")) {
            return FileType.PPT;
        } else if (lowerName.endsWith(".txt") || lowerName.endsWith(".md")) {
            return FileType.TEXT;
        }
        return FileType.UNSUPPORTED;
    }


    /**
     * 解析Word
     */
    public static Document parseWord(InputStream inputStream, String fileName) throws Exception  {

        DocumentParser wordParser = parserMap.get(FileType.WORD);
        if (wordParser == null) {
            throw new UnsupportedOperationException("No parser registered for file type: WORD");
        }
        Document document = wordParser.parse(inputStream);

        // 补充文件名到元数据
        document.metadata().put("file_name", fileName);

        return document;
    }


    /**
     * 解析Excel
     */
    public static Document parseExcelToMarkdown(InputStream inputStream, String fileName) throws Exception {
        Workbook workbook = WorkbookFactory.create(inputStream);
        StringBuilder markdownContent = new StringBuilder();

        for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
            Sheet sheet = workbook.getSheetAt(i);
            String sheetName = sheet.getSheetName();

            markdownContent.append("### Sheet: ").append(sheetName).append("\n\n");

            for (Row row : sheet) {
                if (row == null) continue;

                StringBuilder rowStr = new StringBuilder("| ");
                boolean isFirstRow = (row.getRowNum() == 0);

                for (Cell cell : row) {
                    String cellValue = getCellValueAsString(cell);
                    rowStr.append(cellValue).append(" | ");
                }


                // 如果是第一行（表头），添加 Markdown 表格分隔符
                if (isFirstRow) {
                    StringBuilder separator = new StringBuilder("| ");
                    for (int colIdx = 0; colIdx < row.getLastCellNum(); colIdx++) {
                        separator.append("--- | ");
                    }
                    markdownContent.append(separator.toString().trim()).append("\n");
                }

                markdownContent.append("\n");
            }
            workbook.close();

        }

        // 构造 LangChain4j 的 Document 对象
        Map<String, Object> metadataMap = new HashMap<>();
        metadataMap.put("file_name", fileName);
        metadataMap.put("format", "excel_to_markdown");

        return Document.from(markdownContent.toString(), dev.langchain4j.data.document.Metadata.from(metadataMap));

    }


    /**
     * 提取 Excel 单元格的值
     */
    public static String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    // 避免输出科学计数法，保留原始精度
                    double d = cell.getNumericCellValue();
                    if (d == (long) d) {
                        return String.valueOf((long) d);
                    } else {
                        return String.valueOf(d);
                    }
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                try {
                    return String.valueOf(cell.getNumericCellValue());
                } catch (Exception e) {
                    return cell.getStringCellValue();
                }
            case BLANK:
                return "";
            default:
                return "";
        }
    }


    /**
     * 解析word
     */
    public static Document parseWithRegisteredParser(InputStream inputStream, String fileName, FileType fileType) throws Exception {
        DocumentParser parser = parserMap.get(fileType);
        if (parser == null) {
            throw new UnsupportedOperationException("No parser registered for file type: " + fileType);
        }
        Document document = parser.parse(inputStream);
        document.metadata().put("file_name", fileName);
        return document;
    }



}
