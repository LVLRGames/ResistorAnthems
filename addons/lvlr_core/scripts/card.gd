class_name Card
extends Resource

enum CardType{
	NONE,
	LVLR_CARD,
	PLYR_CARD,
	WRLD_CARD,
	QSTR_CARD,
	PLNR_CARD,
	MSTR_CARD,
	GRPR_CARD,
	LORE_CARD,
	BDGR_CARD,
	TRSR_CARD,
	PRTL_CARD,
}

enum PrivacyLevel{
	PRIVATE,
	WHITELAST,
	BLACKLIST,
	PUBLIC,
	UNIVERSAL,
}

@export var title:String = "Title"
@export var subtitle:String = "Subtitle"
@export var description:String = "Description"
@export var card_type: CardType = CardType.NONE
@export var created_date:int = 0
@export var last_edit_date:int = 0
@export var creator:PLYR   # The user who created the card.
@export var owner:PLYR   # The user who currently owns the card.
@export var privacy_level:PrivacyLevel = PrivacyLevel.PRIVATE
@export var tags:Array[String] = [] # Keywords associated with the card for search purposes.
@export var followers:Array[PLYR] = [] # List of users following the card to receive updates.
