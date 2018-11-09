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
	^ self class = aTextAttribute class and: [ self index = aTextAttribute index ]
]

{ #category : #comparing }
GtSelectorKeywordAttribute >> hash [
	^ self class hash bitXor: self index hash
]

{ #category : #accessing }
GtSelectorKeywordAttribute >> index [
	^ index
]

{ #category : #accessing }
GtSelectorKeywordAttribute >> index: anInteger [
	index := anInteger
]

{ #category : #comparing }
GtSelectorKeywordAttribute >> initialize [
	super initialize.
	self beNotOverwritableByStyler
]
