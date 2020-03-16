Class {
	#name : #GtCoderInstanceVariablesStyler,
	#superclass : #BlTextStyler,
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #testing }
GtCoderInstanceVariablesStyler >> isValidVariableName: aText [
	<return: #Boolean>

	^
		[
			Slot checkValidName: aText asString asSymbol.
			true ]
			on: InvalidSlotName
			do: [ :anError | false ]
]

{ #category : #private }
GtCoderInstanceVariablesStyler >> privateStyle: aText [ 
	<return: #BlText>
	| anIterator isWord |
	
	aText isEmpty
		ifTrue: [ ^ aText ].
	
	anIterator := aText iterator.

	isWord := anIterator peek isCharacter and: [ anIterator peek isSeparator not ].
	
	[ anIterator hasNext ]
		whileTrue: [
			isWord
				ifTrue: [ self styleInstanceVariable: anIterator nextWord ]
				ifFalse: [ self styleWhitespace: anIterator nextWhitespace ].
			isWord := isWord not ].
		
	^ aText
]

{ #category : #private }
GtCoderInstanceVariablesStyler >> styleInstanceVariable: aBlText [
	| isValid |

	isValid := self isValidVariableName: aBlText.
	
	isValid
		ifTrue: [ aBlText foreground: Color darkGray ]
		ifFalse: [ aBlText foreground: Color white ].

	aBlText replacingAdornment: [ :aTBrTextEditorTextualPiece :anEditorElement |
		| aButton |
		
		aButton := (anEditorElement editor segmentBuilder wordStencilBuilder
			wordPadding: (BlInsets top: 3 left: 5 bottom: 3 right: 5);
			segmentPiece: aTBrTextEditorTextualPiece) asElement.
		
		aButton geometry: (BlRectangle cornerRadius: 4).	
		
		isValid
			ifTrue: [ aButton background: BrGlamorousColors neutralBackgroundColor ]
			ifFalse: [ aButton background: BrGlamorousColors errorBackgroundColor ].
		
		{
			aButton.
			BlElement new size: 0@0
		} ]
]

{ #category : #private }
GtCoderInstanceVariablesStyler >> styleWhitespace: aBlText [
	
	aBlText replacingAdornment: [ :aTBrTextEditorTextualPiece :anEditorElement |
		| aButton |
		
		aButton := (anEditorElement editor segmentBuilder wordStencilBuilder
			wordPadding: (BlInsets top: 3 left: 1 bottom: 3 right: 1);
			segmentPiece: aTBrTextEditorTextualPiece) asElement.
		
		{
			aButton.
			BlElement new size: 0@0
		} ]
]
