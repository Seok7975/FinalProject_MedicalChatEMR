package com.emr.www.controller.doctor;

import org.dcm4che3.data.Attributes;
import org.dcm4che3.data.Tag;
import org.dcm4che3.io.DicomInputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class MultiFileUploadController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private DataSource dataSource;
    
    @GetMapping("/multi")
    public String multiFileUpload() {
    	return "upload";
    }

    @PostMapping("/upload-multiple")
    public String handleMultipleFileUpload(@RequestParam("files") List<MultipartFile> files, Model model, RedirectAttributes redirectAttributes) {
        if (files.isEmpty()) {
            return "error"; // 파일이 없을 경우 처리
        }

        for (MultipartFile file : files) {
            try {
                int fileId = saveFileToDatabase(file); // 각 파일을 데이터베이스에 저장
                // 필요한 경우 저장된 파일 ID를 로깅하거나 처리할 수 있습니다.
            } catch (IOException | SQLException e) {
                e.printStackTrace();
                return "error"; // 저장 실패 시 처리
            }
        }

        redirectAttributes.addFlashAttribute("message", "모든 파일이 성공적으로 업로드되었습니다.");
        return "redirect:/multi"; // 업로드 후 리다이렉트
    }

    private int saveFileToDatabase(MultipartFile file) throws IOException, SQLException {
        // 수정된 INSERT SQL 쿼리 (PATIENTKEY 제거)
    	String sql = "INSERT INTO dicom_files (" +
                "file_name, file_data, STUDYINSUID, ACCESSNUM, " +
                "STUDYDATE, STUDYTIME, STUDYID, EXAMCODE, STUDYDESC, MODALITY, " +
                "BODYPART, PID, PNAME, PSEX, PBIRTHDATETIME, PATAGE, " +
                "EXAMSTATUS, REPORTSTATUS, SERIESCNT, IMAGECNT, VERIFYFLAG, VERIFYDATETIME, DEPT, sop_instance_uid) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String checkSql = "SELECT * FROM dicom_files WHERE file_name = ?";
        Attributes attr;

        try (DicomInputStream dis = new DicomInputStream(file.getInputStream())) {
            attr = dis.readDataset(-1, -1);
        }

        Map<String, Object> params = new HashMap<>();
        params.put("file_name", file.getOriginalFilename());
        params.put("file_data", file.getBytes());
        params.put("STUDYINSUID", attr.getString(Tag.StudyInstanceUID));
        params.put("ACCESSNUM", attr.getString(Tag.AccessionNumber));
        params.put("STUDYDATE", attr.getString(Tag.StudyDate));
        params.put("STUDYTIME", attr.getString(Tag.StudyTime));
        params.put("STUDYID", attr.getString(Tag.StudyID));
        params.put("EXAMCODE", attr.getString(Tag.ProcedureCodeSequence));
        params.put("STUDYDESC", attr.getString(Tag.StudyDescription));
        params.put("MODALITY", attr.getString(Tag.Modality));
        params.put("BODYPART", attr.getString(Tag.BodyPartExamined));
        params.put("PID", attr.getString(Tag.PatientID));
        params.put("PNAME", attr.getString(Tag.PatientName));
        params.put("PSEX", attr.getString(Tag.PatientSex));
        params.put("PBIRTHDATETIME", attr.getString(Tag.PatientBirthDate));
        params.put("PATAGE", attr.getString(Tag.PatientAge));
        params.put("EXAMSTATUS", attr.getInt(Tag.ImageIndex, 0));
        params.put("REPORTSTATUS", attr.getString(Tag.CompletionFlag));
        params.put("SERIESCNT", attr.getInt(Tag.NumberOfSeriesRelatedInstances, 0));
        params.put("IMAGECNT", attr.getInt(Tag.NumberOfStudyRelatedInstances, 0));
        params.put("VERIFYFLAG", attr.getString(Tag.VerificationFlag));
        params.put("VERIFYDATETIME", attr.getString(Tag.InstanceCreationDate));
        params.put("DEPT", attr.getString(Tag.InstitutionName));
        params.put("sop_instance_uid", attr.getString(Tag.SOPInstanceUID));

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
             PreparedStatement check = conn.prepareStatement(checkSql)) {

            // Check if file already exists
            check.setString(1, (String) params.get("file_name"));
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                // File already exists
                return rs.getInt("id");
            } else {
                // Set parameters for INSERT statement
                ps.setString(1, (String) params.get("file_name"));
                ps.setBytes(2, (byte[]) params.get("file_data"));
                ps.setString(3, (String) params.get("STUDYINSUID"));
                ps.setString(4, (String) params.get("ACCESSNUM"));
                ps.setString(5, (String) params.get("STUDYDATE"));
                ps.setString(6, (String) params.get("STUDYTIME"));
                ps.setString(7, (String) params.get("STUDYID"));
                ps.setString(8, (String) params.get("EXAMCODE"));
                ps.setString(9, (String) params.get("STUDYDESC"));
                ps.setString(10, (String) params.get("MODALITY"));
                ps.setString(11, (String) params.get("BODYPART"));
                ps.setString(12, (String) params.get("PID"));
                ps.setString(13, (String) params.get("PNAME"));
                ps.setString(14, (String) params.get("PSEX"));
                ps.setString(15, (String) params.get("PBIRTHDATETIME"));
                ps.setString(16, (String) params.get("PATAGE"));
                ps.setInt(17, (Integer) params.get("EXAMSTATUS"));
                ps.setString(18, (String) params.get("REPORTSTATUS"));
                ps.setInt(19, (Integer) params.get("SERIESCNT"));
                ps.setInt(20, (Integer) params.get("IMAGECNT"));
                ps.setString(21, (String) params.get("VERIFYFLAG"));
                ps.setString(22, (String) params.get("VERIFYDATETIME"));
                ps.setString(23, (String) params.get("DEPT"));
                ps.setString(24, (String) params.get("sop_instance_uid"));

                ps.executeUpdate();

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating file failed, no ID obtained.");
                    }
                }
            }
        }
    }
}