Class {
	#name : #GtExpandableCoderViewModel,
	#superclass : #GtSingleCoderViewModel,
	#instVars : [
		'expanded',
		'shouldHaveHeader'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> collapse [
	self expanded: false
]

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> expand [
	self expanded: true
]

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> expanded [
	^ expanded
]

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> expanded: aBoolean [
	expanded = aBoolean ifTrue: [ ^ self ].

	expanded := aBoolean.
	self notifyExpansionChanged: expanded
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> headerElementClass [
	"Return an class of an element that should represent a header of the coder.
	The used element must implement {{gtClass:TGtWithTextualCoderViewModel}} trait."
	<return: #TGtWithTextualCoderViewModel or: nil>

	^ nil
]

{ #category : #initialization }
GtExpandableCoderViewModel >> initialize [
	super initialize.
	expanded := true.
	shouldHaveHeader := true
]

{ #category : #'private - notifying' }
GtExpandableCoderViewModel >> notifyExpansionChanged: aBoolean [
	self announce: (GtExpandableCoderViewModelExpansionChanged new expanded: aBoolean)
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> shouldHaveHeader: aBoolean [
	shouldHaveHeader := aBoolean
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> wantsHeader [
	<return: #Boolean>

	^ shouldHaveHeader and: [ self headerElementClass notNil ]
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> withHeader [
	self shouldHaveHeader: true
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> withoutHeader [
	self shouldHaveHeader: false
]
