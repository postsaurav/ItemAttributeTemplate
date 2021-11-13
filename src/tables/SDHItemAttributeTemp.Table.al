table 50000 "SDH Item Attribute Temp."
{
    DataClassification = CustomerContent;
    DrillDownPageId = "SDH Item Attribute Templates";
    LookupPageId = "SDH Item Attribute Templates";

    fields
    {
        field(1; "Item Template Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Template Code';
            TableRelation = "Item Templ.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(4; "Attribute Name"; Text[250])
        {
            Caption = 'Attribute Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Attribute".Name);
        }

        field(6; "Attribute Value"; Text[250])
        {
            Caption = 'Attribute Value';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item Template Code", "Line No.")
        {
            Clustered = true;
        }
    }



    trigger OnInsert()
    var
        ItemAttributeTemplate: Record "SDH Item Attribute Temp.";
    begin
        ItemAttributeTemplate.SetRange("Item Template Code", Rec."Item Template Code");
        If ItemAttributeTemplate.FindLast() then
            Rec."Line No." := ItemAttributeTemplate."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;
}