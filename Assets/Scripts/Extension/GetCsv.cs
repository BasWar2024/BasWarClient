using Excel;
using OfficeOpenXml;
using System;
using System.Data;
using System.IO;
using System.Text;
using UnityEngine;

public class GetCsv : MonoBehaviour {
    void Start() {
        //string filePath = Application.streamingAssetsPath + "\\data.csv";
        //DataTable dt = OpenCSV(filePath);
        //Debug.Log(dt.Rows[0][0]);
        //Debug.Log(dt.Rows[0][1]);
        //Debug.Log(dt.Rows[0][2]);
    }

    public static DataTable OpenCSV(string filePath)//""csv""table
    {
        DataTable dt = new DataTable();
        using (FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.Read)) {
            using (StreamReader sr = new StreamReader(fs, Encoding.UTF8)) {
                //""
                string strLine = "";
                //""
                string[] aryLine = null;
                string[] tableHead = null;
                //""
                int columnCount = 0;
                //""
                bool IsFirst = true;
                //""CSV""
                while ((strLine = sr.ReadLine()) != null) {
                    if (IsFirst == true) {
                        tableHead = strLine.Split(',');
                        IsFirst = false;
                        columnCount = tableHead.Length;
                        //""
                        for (int i = 0; i < columnCount; i++) {
                            DataColumn dc = new DataColumn(i.ToString());
                            dt.Columns.Add(dc);
                        }

                        aryLine = strLine.Split(',');
                        DataRow dr = dt.NewRow();
                        for (int j = 0; j < columnCount; j++) {
                            dr[j] = aryLine[j];
                        }
                        dt.Rows.Add(dr);
                    }
                    else {
                        aryLine = strLine.Split(',');
                        DataRow dr = dt.NewRow();
                        for (int j = 0; j < columnCount; j++) {
                            dr[j] = aryLine[j];
                        }
                        dt.Rows.Add(dr);
                    }
                }
                if (aryLine != null && aryLine.Length > 0) {
                    dt.DefaultView.Sort = tableHead[0] + " " + "asc";
                }
                sr.Close();
                fs.Close();
                return dt;
            }
        }
    }
}
