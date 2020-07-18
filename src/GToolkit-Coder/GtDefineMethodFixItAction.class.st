Class {
	#name : #GtDefineMethodFixItAction,
	#superclass : #GtFixItAction,
	#instVars : [
		'classOrMetaClass'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #executing }
GtDefineMethodFixItAction >> addCoderAttribute [
	| position stencilBlock |
	position := node keywordsIntervals last last.
	stencilBlock := [ | editorElement coder |
	(classOrMetaClass lookupSelector: node selector)
		ifNil: [ BlElement new ]
		ifNotNil: [ :method | 
			coder := GtMethodCoder forMethod: method.
			coder
				coderLook: GtSourceCoderHeaderLook + GtMethodCoderCategoryLook.
			coder subscribeToSystem.
			coder expanded: true.
			editorElement := coder asElement.
			editorElement
				border: (BlBorder paint: Color veryLightGray width: 1).
			editorElement
				margin:
					(BlInsets
						top: 3
						right: 10
						bottom: 10
						left: 10) ] ].
	methodCoder
		sourceTextDo: [ :text | 
			(text from: position to: position)
				attributes:
					{(BrTextExpandButtonAttribute new
						createdAttributes:
							{(BrTextAdornmentDynamicAttribute new
								beAppend;
								stencil: stencilBlock)};
						attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
								beAppend;
								stencil: stencilBlock ])} ]
]

{ #category : #accessing }
GtDefineMethodFixItAction >> classOrMetaClass: anObject [
	classOrMetaClass := anObject
]

{ #category : #executing }
GtDefineMethodFixItAction >> clearFixItAttribute [
	| position |
	position := node keywordsIntervals last last.
	methodCoder
		sourceTextDo: [ :text | 
			(text from: position to: position)
				clearAttributes: [ :each | each isKindOf: GtFixItAttribute ] ]
]

{ #category : #private }
GtDefineMethodFixItAction >> compileMethod [
	| refactoring |
	refactoring := RBAddMethodRefactoring
		addMethod: self methodSource
		toClass: classOrMetaClass
		inProtocols: {(methodCoder category ifNil: [ #accessing ])}.
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
