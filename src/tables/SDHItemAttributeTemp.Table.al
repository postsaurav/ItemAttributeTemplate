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
            Caption = 'Line No.';
            NotBlank = true;
        }
        field(3; "Attribute ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Attribute ID';
            TableRelation = "Item Attribute" where(Blocked = const(false));

            trigger OnValidate()
            var
                ItemAttributeTemplate: Record "SDH Item Attribute Temp.";
                AttributeNameAlreadyExistLbl: Label 'Item Attribute %1 already exist.', Comment = '%1 = Attribute Name.';
            begin
                ItemAttributeTemplate.SetRange("Item Template Code", Rec."Item Template Code");
                ItemAttributeTemplate.SetRange("Attribute ID", Rec."Attribute ID");
                if ItemAttributeTemplate.FindSet() then begin
                    ItemAttributeTemplate.SetAutoCalcFields("Attribute Name");
                    If ItemAttributeTemplate.Count >= 1 then
                        Error(AttributeNameAlreadyExistLbl, ItemAttributeTemplate."Attribute Name");
                end;
            end;
        }
        field(4; "Attribute Name"; Text[250])
        {
            Caption = 'Attribute Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Attribute".Name Where(ID = field("Attribute ID")));

            trigger OnLookup()
            var
                ItemAttribute: Record "Item Attribute";
                ItemAttributes: Page "Item Attributes";
            begin
                ItemAttributes.LookupMode(true);
                ItemAttribute.SetRange(Blocked, false);
                ItemAttributes.SetTableView(ItemAttribute);
                if ItemAttributes.RunModal() = Action::LookupOK then begin
                    ItemAttributes.GetRecord(ItemAttribute);
                    Validate("Attribute ID", ItemAttribute.ID);
                end;
            end;
        }

        field(5; "Attribute Value ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Attribute Value ID';
            TableRelation = "Item Attribute Value" where(Blocked = const(false));
        }
        field(6; "Attribute Value"; Text[250])
        {
            Caption = 'Attribute Value';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ItemAttributeValue: Record "Item Attribute Value";
                ItemAttributeValues: Page "Item Attribute Values";
            begin
                ItemAttributeValues.LookupMode(true);
                ItemAttributeValue.SetRange(Blocked, false);
                ItemAttributeValue.SetRange("Attribute ID", Rec."Attribute ID");
                ItemAttributeValues.SetTableView(ItemAttributeValue);
                if ItemAttributeValues.RunModal() = Action::LookupOK then begin
                    ItemAttributeValues.GetRecord(ItemAttributeValue);
                    "Attribute Value ID" := ItemAttributeValue.ID;
                    "Attribute Value" := ItemAttributeValue.Value;
                end;
            end;

            trigger OnValidate()
            begin
                If "Attribute Value" = xRec."Attribute Value" then
                    exit;

                if "Attribute Value" = '' then begin
                    Validate("Attribute Value ID", 0);
                    exit;
                end;

                if not ManualValueAllowed() then begin
                    if not ValidValue() then
                        Error('Invalid Value for Attribute %1', "Attribute Name")
                end else
                    AddNewAttributeValue();
            end;
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

    local procedure ManualValueAllowed(): Boolean
    var
        ItemAttribute: Record "Item Attribute";
    begin
        if ItemAttribute.Get("Attribute ID") then
            exit(not (ItemAttribute.Type = ItemAttribute.Type::Option));
        exit(true);
    end;

    local procedure ValidValue(): Boolean
    var
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        ItemAttributeValue.SetRange("Attribute ID", Rec."Attribute ID");
        ItemAttributeValue.SetRange(Blocked, false);
        ItemAttributeValue.SetRange(Value, Rec."Attribute Value");
        if ItemAttributeValue.FindFirst() then
            Rec."Attribute Value ID" := ItemAttributeValue.ID
        else
            exit(false);
        exit(true);
    end;

    local procedure AddNewAttributeValue()
    var
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
        InvalidInputLbl: Label 'Invalid Value. Attribute %1 Requires a %2 Value.', Comment = '%1=Attribute Name, %2=Attribute Value.';
    begin
        if not ItemAttribute.Get(Rec."Attribute ID") then
            exit;

        ItemAttributeValue.Init();
        ItemAttributeValue."Attribute ID" := ItemAttribute.ID;
        ItemAttributeValue.Value := Rec."Attribute Value";
        Case ItemAttribute.Type of
            ItemAttribute.Type::Date:
                if not Evaluate(ItemAttributeValue."Date Value", ItemAttributeValue.Value) then
                    Error(InvalidInputLbl, ItemAttribute.Name, ItemAttribute.Type);
            ItemAttribute.Type::Decimal, ItemAttribute.Type::Integer:
                if not Evaluate(ItemAttributeValue."Numeric Value", ItemAttributeValue.Value) then
                    Error(InvalidInputLbl, ItemAttribute.Name, ItemAttribute.Type);
        End;
        ItemAttributeValue.Insert(true);
        Rec."Attribute Value ID" := ItemAttributeValue.ID;
    end;
}