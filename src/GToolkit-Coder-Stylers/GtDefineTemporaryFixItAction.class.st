Class {
	#name : #GtDefineTemporaryFixItAction,
	#superclass : #GtFixItAction,
	#category : #'GToolkit-Coder-Stylers-FixIt'
}

{ #category : #accessing }
GtDefineTemporaryFixItAction >> description [
	^ 'Add temporary variable ' , node name
]

{ #category : #executing }
GtDefineTemporaryFixItAction >> execute [
	| ast newSource location declaration |
	ast := sourceCoder rbAST.
	newSource := sourceCoder currentSourceString.
	ast body rightBar isNil
		ifTrue: [ location := ast body start - 1.
			declaration := '| ' , node name , ' |' , String cr , String tab ]
		ifFalse: [ location := ast body rightBar - 1.
			declaration := ((newSource at: location) isSeparator
				ifTrue: [ '' ]
				ifFalse: [ ' ' ]) , node name , ' ' ].
	newSource := (newSource first: location) , declaration
		, (newSource allButFirst: location).
	sourceCoder currentSourceString: newSource
]
