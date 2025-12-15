Class {
	#name : #GtExpandableCoderViewModelExpansionChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'expanded',
		'source'
	],
	#category : 'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtExpandableCoderViewModelExpansionChanged >> expanded [
	^ expanded
]

{ #category : #accessing }
GtExpandableCoderViewModelExpansionChanged >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #accessing }
GtExpandableCoderViewModelExpansionChanged >> source [
	^ source
]

{ #category : #accessing }
GtExpandableCoderViewModelExpansionChanged >> source: anObject [
	source := anObject
]
