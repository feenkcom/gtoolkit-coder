Class {
	#name : #GtASTStyler,
	#superclass : #BlTextStyler,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #styling }
GtASTStyler >> extraStyle: aText ast: ast [
	
]

{ #category : #'gt-extension' }
GtASTStyler >> gtViewTextFor: aView [
	<gtView>
	text ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Last styled text';
		priority: 105;
		text: [ text ]
]

{ #category : #private }
GtASTStyler >> parse: aText [
	| code |
	code := aText asString.
	^ RBParser parseFaultyMethod: code
]

{ #category : #private }
GtASTStyler >> privateStyle: aText [
	| ast |
	ast := self parse: aText.
	ast isNil
		ifTrue: [ ^ aText ].
	[ self style: aText ast: ast.
	self extraStyle: aText ast: ast ]
		on: Error
		do: [ :e | e return ].
	^ aText
]

{ #category : #styling }
GtASTStyler >> style: aText ast: ast [
	text := aText.
	self visitNode: ast
]

{ #category : #private }
GtASTStyler >> styleFrom: from to: to with: attributes [
	(text from: from to: to) attributes: attributes
]

{ #category : #accessing }
GtASTStyler >> typeOf: aNode in: aClass [
	aNode isSelf
		ifTrue: [ ^ aClass ].
	aNode isSuper
		ifTrue: [ ^ aClass ifNotNil: [ :class | class superclass ] ].
	aNode isLiteralNode
		ifTrue: [ ^ aNode value class ].
	aNode isDynamicArray
		ifTrue: [ ^ {} class ].
	aNode isMessage
		ifTrue: [ aNode selector = #class
				ifTrue: [ ^ (self typeOf: aNode receiver in: aClass)
						ifNotNil: [ :class | class class ] ].
			(#(new new:) includes: aNode selector)
				ifTrue: [ ^ (self typeOf: aNode receiver in: aClass)
						ifNotNil: [ :class | class instanceSide ] ] ].
	aNode isVariable
		ifTrue: [ aNode binding
				ifNotNil: [ :binding | 
					binding isLiteralVariable
						ifTrue: [ binding value ifNotNil: [ :object | ^ object class ] ].
					(binding isSpecialVariable and: [ binding isThisContext ])
						ifTrue: [ ^ Context ] ] ].
	^ nil
]

{ #category : #visiting }
GtASTStyler >> visitArgumentNodes: aNodeCollection [ 
	"Sent *once* when visiting method and block nodes"
	^aNodeCollection do: [ :each | self visitNode: each ]
]

{ #category : #visiting }
GtASTStyler >> visitTemporaryDeclarationNode: aTemporaryDeclarationNode [
	"| temp |
	temp is a temporary node as we can find in the body of methods, but it can't be visited the same way.
	IT redirects the message on argumentNodeVisitor as a way to keep retrocompatibility"

	^ self visitNode: aTemporaryDeclarationNode
]
