Class {
	#name : #GtCoderActivatableAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'enabledBlock',
		'updateAnnouncement'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #accessing }
GtCoderActivatableAction >> enabled: aBlock [
	enabledBlock := aBlock
]

{ #category : #initialization }
GtCoderActivatableAction >> initialize [
	super initialize.
	
	enabledBlock := [ :aUIModel | true ].
	updateAnnouncement := nil
]

{ #category : #accessing }
GtCoderActivatableAction >> updateWhen: anAnnouncementClass [
	updateAnnouncement := anAnnouncementClass
]
