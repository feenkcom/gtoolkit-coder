Class {
	#name : 'GtExtractMethodSelectorKeywordAttribute',
	#superclass : 'BlTextAttribute',
	#instVars : [
		'index'
	],
	#category : 'GToolkit-Coder-AddOns-Extract method'
}

{ #category : 'instance creation' }
GtExtractMethodSelectorKeywordAttribute class >> keywordIndex: anInteger [
	^ self new
		index: anInteger;
		yourself
]

{ #category : 'comparing' }
GtExtractMethodSelectorKeywordAttribute >> equals: aTextAttribute [
	^ self index = aTextAttribute index
]

{ #category : 'comparing' }
GtExtractMethodSelectorKeywordAttribute >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: self index hash
]

{ #category : 'accessing' }
GtExtractMethodSelectorKeywordAttribute >> index [
	^ index
]

{ #category : 'accessing' }
GtExtractMethodSelectorKeywordAttribute >> index: anInteger [
	index := anInteger
]

{ #category : 'initialization' }
GtExtractMethodSelectorKeywordAttribute >> initialize [
	super initialize.

	self beNotOverwritableByStyler
]
