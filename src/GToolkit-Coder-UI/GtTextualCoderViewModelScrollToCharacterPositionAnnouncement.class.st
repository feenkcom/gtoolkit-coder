Class {
	#name : #GtTextualCoderViewModelScrollToCharacterPositionAnnouncement,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'characterPosition',
		'lineIndex'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelScrollToCharacterPositionAnnouncement >> characterPosition [
	^ characterPosition
]

{ #category : #accessing }
GtTextualCoderViewModelScrollToCharacterPositionAnnouncement >> characterPosition: anObject [
	characterPosition := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelScrollToCharacterPositionAnnouncement >> lineIndex [
	^ lineIndex
]

{ #category : #accessing }
GtTextualCoderViewModelScrollToCharacterPositionAnnouncement >> lineIndex: anObject [
	lineIndex := anObject
]
