Class {
	#name : 'GtDefineTemporaryFixItAction',
	#superclass : 'GtFixItVariableNodeAction',
	#category : 'GToolkit-Coder-AddOns-FixIt'
}

{ #category : 'accessing' }
GtDefineTemporaryFixItAction >> description [
	^ 'Add temporary variable ' , self nodeName
]

{ #category : 'executing' }
GtDefineTemporaryFixItAction >> executeOn: anEditorElement [
	| ast newSource location declaration |

	ast := sourceCoder rbAST.
	newSource := sourceCoder currentSourceString.
	ast body rightBar isNil
		ifTrue: [ location := ast body start - 1.
			declaration := '| ' , self nodeName , ' |' , String cr , String tab ]
		ifFalse: [ location := ast body rightBar - 1.
			declaration := ((newSource at: location) isSeparator
				ifTrue: [ '' ]
				ifFalse: [ ' ' ]) , self nodeName , ' ' ].

	newSource := (newSource first: location) , declaration
		, (newSource allButFirst: location).
	sourceCoder currentSourceString: newSource
]

{ #category : 'accessing' }
GtDefineTemporaryFixItAction >> id [
	<return: #BlElementId>

	^ GtDefineTemporaryVariableFixItActionElementId
]
