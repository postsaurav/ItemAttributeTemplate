pageextension 50000 "SDH Item Templ. List" extends "Item Templ. List"
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
