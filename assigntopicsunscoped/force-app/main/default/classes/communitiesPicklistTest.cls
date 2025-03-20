/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

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