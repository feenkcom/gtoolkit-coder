Class {
	#name : #GtCoderInstanceVariableStyler,
	#superclass : #BlTextStyler,
	#category : 'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #testing }
GtCoderInstanceVariableStyler >> isValidVariableName: aText [
	<return: #Boolean>

	^
		[
			Slot checkValidName: aText asString trimmed asSymbol.
			true ]
			on: InvalidSlotName
			do: [ :anError | false ]
]

{ #category : #private }
GtCoderInstanceVariableStyler >> privateStyle: aText [ 
	<return: #BlText>
	
	aText isEmpty
		ifTrue: [ ^ aText ].
		
	(self isValidVariableName: aText)
		ifFalse: [
			aText
				foreground: Color white;
				highlight: BrGlamorousColors errorBackgroundColor ].
		
	^ aText
]
