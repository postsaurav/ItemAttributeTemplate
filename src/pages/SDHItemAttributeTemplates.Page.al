page 50000 "SDH Item Attribute Templates"
{
    Caption = 'Item Attribute Templates';
    PageType = List;
    SourceTable = "SDH Item Attribute Temp.";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item Template Code"; Rec."Item Template Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Attribute Name"; Rec."Attribute Name")
                {
                    ToolTip = 'Specifies the value of the Attribute Name field.';
                    ApplicationArea = All;
                    trigger OnAfterLookup(Selected: RecordRef)
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Attribute Value"; Rec."Attribute Value")
                {
                    ToolTip = 'Specifies the value of the Attribute Value field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
