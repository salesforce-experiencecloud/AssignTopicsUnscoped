/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

global class communitiesPicklist extends VisualEditor.DynamicPickList {
    
    VisualEditor.DesignTimePageContext context;

    global communitiesPicklist(VisualEditor.DesignTimePageContext context) {
       this.context = context;
    }

    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow novalue = new VisualEditor.DataRow('None', '');
        return novalue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        
        VisualEditor.DataRow novalue = new VisualEditor.DataRow('Internal Org', '');
        myValues.addRow(novalue);

        List<Network> networkList = [SELECT Id, Name FROM Network ORDER BY Name];

        for(Network n : networkList)
        {
            VisualEditor.DataRow value = new VisualEditor.DataRow('Community - ' + n.Name, n.Id+'');
            myValues.addRow(value);
        }
        
        return myValues;
    }

}
