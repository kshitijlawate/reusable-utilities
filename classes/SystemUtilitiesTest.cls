/*
Author: Kshitij Lawate

Permission is hereby granted, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction.

*Class Details*
Test class for SystemUtilities
*/
@isTest
public with sharing class SystemUtilitiesTest 
{
    @istest
    public static void systemUtilitiesTest() 
    {
        User currentUser = [SELECT Id, Profile.Name, CreatedBy.Profile.CreatedDate, Name, MobilePhone 
                                FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        system.assertEquals(currentUser.Profile.Name, SystemUtilities.fetchFieldValue(currentUser, 'Profile.Name'));
        system.assertEquals(currentUser.Id, SystemUtilities.fetchFieldValue(currentUser, 'Id'));
        system.assertEquals(currentUser.CreatedBy.Profile.CreatedDate, SystemUtilities.fetchFieldValue(currentUser, 'CreatedBy.Profile.CreatedDate'));

        List<String> lstFieldApis = new List<String> 
        {
            'Name', 'Profile.Name', 'CreatedBy.Profile.CreatedDate', 'MobilePhone'
        };
        String formattedString = 'The current user\'\'s name is {0} and his profile is {1} and was created on {2}. His mobile phone is {3}.';

        String fieldMergedString = SystemUtilities.populateFormattedString (formattedString, currentUser, lstFieldApis);

        system.assert(fieldMergedString.contains(currentUser.Name));
        system.assert(fieldMergedString.contains(currentUser.Profile.Name));
    }

    @isTest
    public static void RecordTypeUtilityTest()
    {
        Id recTypeId = RecordTypeUtility.fetchRecordTypeIdByDevName('Account', 'Master');

        system.assertEquals(RecordTypeUtility.fetchRecordTypeDevNameById('Account', recTypeId), 'Master');
        system.assertEquals(RecordTypeUtility.fetchRecordTypeNameById('Account', recTypeId), 'Master');
    }
}