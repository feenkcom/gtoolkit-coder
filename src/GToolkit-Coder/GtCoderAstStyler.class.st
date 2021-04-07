Class {
	#name : #GtCoderAstStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'coderViewModel'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'api - styling' }
GtCoderAstStyler >> attribute: aTextAttribute from: aStart to: anEnd [
	self attributes: { aTextAttribute } from: aStart to: anEnd
]

{ #category : #'api - styling' }
GtCoderAstStyler >> attributes: anAttributesCollection from: aStart to: anEnd [
	
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

{ #category : #accessing }
GtCoderAstStyler >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtCoderAstStyler >> coderViewModel: anObject [
	coderViewModel := anObject
]

{ #category : #'api - styling' }
GtCoderAstStyler >> extraStyle: aText ast: theAst [
]

{ #category : #private }
GtCoderAstStyler >> privateStyle: aText [
	| theAst |
	
	"Styling happens in a non-UI process, therefore it is fine to wait until AST is computed in a blocking way"
	theAst := self coderViewModel coderModel astAwait.
	theAst
		ifNil: [ ^ aText ].

	[
		self style: aText ast: theAst.
		self extraStyle: aText ast: theAst ]
			on: Error
			do: [ :anError |
				anError emit.

				NonInteractiveTranscript stdout
					nextPutAll: '[';
					nextPutAll: self class name;
					nextPutAll: '] ';
					print: anError;
					cr ].

	^ aText
]

{ #category : #'api - styling' }
GtCoderAstStyler >> style: aText ast: theAst [
	self subclassResponsibility
]
