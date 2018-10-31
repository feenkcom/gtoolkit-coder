Class {
	#name : #GtExampleStatusAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'result'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtExampleStatusAttribute class >> forResult: anExampleResult [
	^ self new
		result: anExampleResult;
		yourself
]

{ #category : #accessing }
GtExampleStatusAttribute >> affect: aBrText in: anEditorElement [
	| element |
	element := result isNil
		ifTrue: [ BrGlamorousIcons graycircle asElement ]
		ifFalse: [
			result isSuccess
				ifTrue: [ BrGlamorousIcons greencircle asElement ]
				ifFalse: [ 
					result isFailure
						ifTrue: [ BrGlamorousIcons redcircle asElement ]
						ifFalse: [ 
							result isError
								ifTrue: [ BrGlamorousIcons redcircle asElement ]
								ifFalse: [ BrGlamorousIcons graycircle asElement ] ] ] ].
	^ element
		margin:
			(BlInsets
				top: 2
				left: 0
				bottom: 0
				right: 0)
]

{ #category : #'initialize-release' }
GtExampleStatusAttribute >> initialize [
	super initialize.
	self beAppend
]

{ #category : #accessing }
GtExampleStatusAttribute >> result [
	^ result
]

{ #category : #accessing }
GtExampleStatusAttribute >> result: exampleResult [
	result := exampleResult
]
