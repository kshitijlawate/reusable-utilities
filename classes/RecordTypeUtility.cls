/*
Author: Kshitij Lawate

Permission is hereby granted, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction.

*Class Details*
Class with resusable utilities to fetch record type Id, Names, 
Covered with test class SystemUtilitiesTest
*/
public with sharing class RecordTypeUtility 
{  
    //map with Sobject Name as Key and Map of Record Type Dev name to Record Type Info as value 
    static Map<String, Map<String, Schema.RecordTypeInfo>> mapObjNameToRecTypeDevNameInfos= new Map<String, Map<String, Schema.RecordTypeInfo>>(); 
    //map with Sobject Name as Key and Map of Record Type Id and record type info as value 
    static Map<String, Map<Id, Schema.RecordTypeInfo>> mapObjNameToRecTypeIdInfos = new Map<String, Map<Id, Schema.RecordTypeInfo>>(); 

    /**
     * method to return record type info from a static map based on sobject name and record type dev name
     */
    private static Schema.RecordTypeInfo getRecordTypeInfo(String sobjName, String recTypeDevName)
    {
        Schema.RecordTypeInfo rtInfo;
        Schema.DescribeSObjectResult objDescribe = SystemUtilities.getSobjectDescribe(sobjName);

        if(objDescribe != null && !mapObjNameToRecTypeDevNameInfos.containsKey(sobjName))
        {
            mapObjNameToRecTypeDevNameInfos.put(sobjName, objDescribe.getRecordTypeInfosByDeveloperName());
            rtInfo = objDescribe.getRecordTypeInfosByDeveloperName().get(recTypeDevName);

            mapObjNameToRecTypeIdInfos.put(sobjName, objDescribe.getRecordTypeInfosById());
        }
        else if(objDescribe != null )
        {
            Map<String, Schema.RecordTypeInfo> mapRTInfo = mapObjNameToRecTypeDevNameInfos.get(sobjName);
            rtInfo = mapRTInfo.get(recTypeDevName);
        }
        return rtInfo;        
    }

    /**
     * method to return record type info from a static map based on sobject name and record type Id
     */
    private static Schema.RecordTypeInfo getRecordTypeInfo(String sobjName, Id recTypeId)
    {
        Schema.RecordTypeInfo rtInfo;
        Schema.DescribeSObjectResult objDescribe = SystemUtilities.getSobjectDescribe(sobjName);

        if(objDescribe != null && !mapObjNameToRecTypeIdInfos.containsKey(sobjName))
        {
            mapObjNameToRecTypeIdInfos.put(sobjName, objDescribe.getRecordTypeInfosById());
            rtInfo = objDescribe.getRecordTypeInfosById().get(recTypeId);

            mapObjNameToRecTypeDevNameInfos.put(sobjName, objDescribe.getRecordTypeInfosByDeveloperName());
        }
        else if(objDescribe != null )
        {
            Map<Id, Schema.RecordTypeInfo> mapRTInfo = mapObjNameToRecTypeIdInfos.get(sobjName);
            rtInfo = mapRTInfo.get(recTypeId);
        }
        return rtInfo;        
    }

    /**
     * method to return record type id based on sobject name and record type dev name 
     */
    public static Id fetchRecordTypeIdByDevName( String sobjName, String recTypeDevName)
    {   
        Id recTypeId;

        String sobjectName = sobjName.toLowerCase();

        Schema.RecordTypeInfo rtInfo = getRecordTypeInfo(sobjectName, recTypeDevName);

        if(rtInfo != null)
        {
            recTypeId = rtInfo.getRecordTypeId();
        }

        return recTypeId;
    }
    /**
     * method to return record type dev name based on sobject name and record type Id
     */
    public static String fetchRecordTypeDevNameById( String sobjName, Id recTypeId)
    {   
        String recTypeDevName;

        String sobjectName = sobjName.toLowerCase();

        Schema.RecordTypeInfo rtInfo = getRecordTypeInfo(sobjectName, recTypeId);

        if(rtInfo != null)
        {
            recTypeDevName = rtInfo.getDeveloperName();
        }

        return recTypeDevName;
    }
    /**
     * method to return record type name based on sobject name and record type Id
     */
    public static String fetchRecordTypeNameById( String sobjName, Id recTypeId)
    {   
        String recTypeName;

        String sobjectName = sobjName.toLowerCase();

        Schema.RecordTypeInfo rtInfo = getRecordTypeInfo(sobjectName, recTypeId);

        if(rtInfo != null)
        {
            recTypeName = rtInfo.getName();
        }

        return recTypeName;
    }
}