Class {
	#name : #GtDefineMethodFixItAction,
	#superclass : #GtFixItAction,
	#instVars : [
		'classOrMetaClass'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #executing }
GtDefineMethodFixItAction >> addCoderAttribute [
	| position |
	position := node keywordsIntervals last last.
	sourceCoder
		sourceTextDo: [ :text | 
			(text from: position to: position)
				attributes:
					{((GtMethodExpanderAttribute
						forClass: classOrMetaClass
						andSelector: node selector) isExpanded: true)} ]
]

{ #category : #accessing }
GtDefineMethodFixItAction >> attributePosition [
	^ node keywordsIntervals last last
]

{ #category : #accessing }
GtDefineMethodFixItAction >> classOrMetaClass: anObject [
	classOrMetaClass := anObject
]

{ #category : #private }
GtDefineMethodFixItAction >> compileMethod [
	| refactoring |
	refactoring := RBAddMethodRefactoring
		addMethod: self methodSource
		toClass: classOrMetaClass
		inProtocols: {(sourceCoder category ifNil: [ #accessing ])}.
	refactoring execute
]

{ #category : #accessing }
GtDefineMethodFixItAction >> description [
	^ 'Create method ' , node selector , ' in class '
		, classOrMetaClass name
]

{ #category : #executing }
GtDefineMethodFixItAction >> execute [
	self compileMethod.
	self clearFixItAttribute.
	self addCoderAttribute
]

{ #category : #private }
GtDefineMethodFixItAction >> methodSource [
	node arguments isEmpty
		ifTrue: [ ^ node selector ].
	^ String
		streamContents: [ :stream | 
			| variables baseName name index |
			variables := Set new.
			node selectorParts
				with: node arguments
				do: [ :sel :arg | 
					stream
						nextPutAll: sel;
						space.
					baseName := (arg isTemp or: [ arg isArgument ])
						ifTrue: [ arg name ]
						ifFalse: [ 'anObject' ].
					index := 0.
					name := baseName.
					[ variables includes: name ]
						whileTrue: [ index := index + 1.
							name := baseName , index printString ].
					variables add: name.
					stream
						nextPutAll: name;
						space ] ]
]
