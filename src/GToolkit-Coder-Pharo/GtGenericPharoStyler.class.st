Class {
	#name : #GtGenericPharoStyler,
	#superclass : #GtCoderAstStyler,
	#traits : 'TGtPharoProgramNodeVisitor',
	#classTraits : 'TGtPharoProgramNodeVisitor classTrait',
	#category : #'GToolkit-Coder-Pharo-Styler'
}

{ #category : #'api - styling' }
GtGenericPharoStyler >> attribute: aTextAttribute from: aStart to: anEnd [
	self attributes: { aTextAttribute } from: aStart to: anEnd
]

{ #category : #'api - styling' }
GtGenericPharoStyler >> attributes: anAttributesCollection from: aStart to: anEnd [
	
	[ text attributes: anAttributesCollection from: aStart to: anEnd. ]
		on: Error
		do: [ :anError |
			anError emit.

			NonInteractiveTranscript stdout
				nextPutAll: '[';
				nextPutAll: self class name;
				nextPutAll: '] ';
				nextPutAll: 'Was not able to apply attributes ';
				print: (anAttributesCollection collect: [ :each | each class name ] as: Array);
				nextPutAll: ' from ';
				print: aStart;
				nextPutAll: ' to ';
				print: anEnd;
				nextPutAll: ' on text of size ';
				print: text size;
				cr ].
]

{ #category : #'api - styling' }
GtGenericPharoStyler >> style: aText ast: theAst [
	text := aText.
	[ self accept: theAst ]
		ensure: [ text := nil ]
]
