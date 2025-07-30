Class {
	#name : #GtTextualCoderViewModelExpansionChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'expanded'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelExpansionChanged >> expanded [
	^ expanded
]

{ #category : #accessing }
GtTextualCoderViewModelExpansionChanged >> expanded: aBoolean [
	expanded := aBoolean
]
