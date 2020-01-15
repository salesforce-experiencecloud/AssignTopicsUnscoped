@isTest
private class communitiesPicklistTest {
    
    public static testMethod void test_success_ccp_objectNamePicklist()
    {
        communitiesPicklist cp = new communitiesPicklist(null);
        VisualEditor.DataRow dr = cp.getDefaultValue();
        System.assert(dr.getValue() == '');
        
        VisualEditor.DynamicPickListRows dpr = cp.getValues();
        System.assert(dpr != null);
    }

}
