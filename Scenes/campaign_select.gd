extends Button

@export var nameLabel: Label
@export var descriptionLabel: Label

var camapign: CampaignDescription

func set_desc(campaign: CampaignDescription):
	self.camapign = camapign
	nameLabel.text = campaign.name
	descriptionLabel.text = campaign.description
