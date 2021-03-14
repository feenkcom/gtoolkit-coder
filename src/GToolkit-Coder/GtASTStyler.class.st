Class {
	#name : #GtAstStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'coderViewModel'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #accessing }
GtAstStyler >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtAstStyler >> coderViewModel: anObject [
	coderViewModel := anObject
]

{ #category : #'api - styling' }
GtAstStyler >> extraStyle: aText ast: theAst [
	
]

{ #category : #private }
GtAstStyler >> privateStyle: aText [
	| theAst |
	
	"Styling happens in a non-UI process, therefore it is fine to wait until AST is computed in a blocking way"
	theAst := self coder astAwait.
	theAst
		ifNil: [ ^ aText ].
	
	[
		self style: aText ast: theAst.
		self extraStyle: aText ast: theAst ]
			on: Error
			do: [ :e |
				NonInteractiveTranscript stdout
					nextPutAll: '[';
					nextPutAll: self class name;
					nextPutAll: '] ';
					print: e;
					cr.
				e return ].
	
	^ aText
]

{ #category : #'api - styling' }
GtAstStyler >> style: aText ast: theAst [
	self subclassResponsibility
]
