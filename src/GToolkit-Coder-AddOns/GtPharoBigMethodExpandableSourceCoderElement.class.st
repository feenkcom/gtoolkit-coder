Class {
	#name : #GtPharoBigMethodExpandableSourceCoderElement,
	#superclass : #GtExpandableMethodCoderElement,
	#category : #'GToolkit-Coder-AddOns-Big Methods'
}

{ #category : #'private - instance creation' }
GtPharoBigMethodExpandableSourceCoderElement >> newExpandedElement [
	| anExpandedElement |
	anExpandedElement := GtPharoBigMethodExpandedSourceCoderElement new.

	textualCoderViewModel
		ifNotNil: [ :aCoder | self assignExpandedCoder: aCoder to: anExpandedElement ].

	^ anExpandedElement
]
