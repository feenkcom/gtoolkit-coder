Class {
	#name : #GtCompositeExplanationLinkStyler,
	#superclass : #GtSourceExplanationLinkStyler,
	#instVars : [
		'links'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'as yet unclassified' }
GtCompositeExplanationLinkStyler class >> forLinks: aCollection [
	^ self new
		forLinks: aCollection;
		yourself
]

{ #category : #'as yet unclassified' }
GtCompositeExplanationLinkStyler >> forLinks: aCollection [
	links := aCollection
]

{ #category : #accessing }
GtCompositeExplanationLinkStyler >> links [
	^ links.
]

{ #category : #styling }
GtCompositeExplanationLinkStyler >> style: aText ast: ast [
	self links do: [ :each | each style: aText ast: ast ]
]
