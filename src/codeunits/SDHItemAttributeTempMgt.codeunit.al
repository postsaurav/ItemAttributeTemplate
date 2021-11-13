codeunit 50000 "SDH Item Attribute Temp. Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Templ. Mgt.", 'OnApplyTemplateOnBeforeItemModify', '', false, False)]
    local procedure AddItemAttributes(var Item: Record Item; ItemTempl: Record "Item Templ.")
    var
        ItemAttributeTemplate: Record "SDH Item Attribute Temp.";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        ItemAttributeTemplate.SetRange("Item Template Code", ItemTempl.Code);
        if ItemAttributeTemplate.FindSet() then
            repeat
                ItemAttributeValueMapping.Init();
                ItemAttributeValueMapping."Table ID" := Database::Item;
                ItemAttributeValueMapping."No." := Item."No.";
                ItemAttributeValueMapping."Item Attribute ID" := ItemAttributeTemplate."Attribute ID";
                ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeTemplate."Attribute Value ID";
                ItemAttributeValueMapping.Insert(true);
            until (ItemAttributeTemplate.Next() = 0);
    end;
}
