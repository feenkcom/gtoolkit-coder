Class {
	#name : #GtExpandableCoderViewModelExpansionChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'expanded'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtExpandableCoderViewModelExpansionChanged >> expanded [
	^ expanded
]

{ #category : #accessing }
GtExpandableCoderViewModelExpansionChanged >> expanded: aBoolean [
	expanded := aBoolean
]
