Class {
	#name : #GtSelectorKeywordAttribute,
	#superclass : #BlTextAttribute,
	#instVars : [
		'index'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
GtSelectorKeywordAttribute class >> keywordIndex: anInteger [
	^ self new
		index: anInteger;
		yourself
]

{ #category : #comparing }
GtSelectorKeywordAttribute >> equals: aTextAttribute [
	^ self index = aTextAttribute index
]

{ #category : #comparing }
GtSelectorKeywordAttribute >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: self index hash
]

{ #category : #accessing }
GtSelectorKeywordAttribute >> index [
	^ index
]

{ #category : #accessing }
GtSelectorKeywordAttribute >> index: anInteger [
	index := anInteger
]

{ #category : #initialization }
GtSelectorKeywordAttribute >> initialize [
	super initialize.
	self beNotOverwritableByStyler
]
