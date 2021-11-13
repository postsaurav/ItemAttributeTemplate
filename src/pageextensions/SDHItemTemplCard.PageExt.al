pageextension 50001 "SDH Item Templ. Card" extends "Item Templ. Card"
{
    actions
    {
        addlast(Navigation)
        {
            action(Attributes)
            {
                ApplicationArea = All;
                Caption = 'Attributes';
                Image = Category;
                RunObject = Page "SDH Item Attribute Templates";
                RunPageLink = "Item Template Code" = field(Code);
                ToolTip = 'Executes the Attributes action.';
            }
        }
    }
}
