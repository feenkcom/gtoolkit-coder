Class {
	#name : #GtMultipleCodersViewModel,
	#superclass : #Object,
	#instVars : [
		'coder',
		'coderUIModels'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtMultipleCodersViewModel >> announcer [
	self
		deprecated: 'Use #coder announcer instead.'
		transformWith: '`@receiver announcer' -> '`@receiver coder announcer'.

	^ self coder announcer
]

{ #category : #converting }
GtMultipleCodersViewModel >> asCoderUIModel [
	^ self
]

{ #category : #converting }
GtMultipleCodersViewModel >> asElement [
	^ self elementClass new
		codersUIModel: self;
		yourself
]

{ #category : #accessing }
GtMultipleCodersViewModel >> coder [
	<return: #GtCodersModel>
	
	^ coder
]

{ #category : #accessing }
GtMultipleCodersViewModel >> coder: aGtCodersModel [
	coder := aGtCodersModel.
	self updateCoderUIModels
]

{ #category : #updating }
GtMultipleCodersViewModel >> coderUIModelFor: aCoder [
	^ aCoder asCoderUIModel
]

{ #category : #accessing }
GtMultipleCodersViewModel >> coderUIModels [
	^ coderUIModels
]

{ #category : #accessing }
GtMultipleCodersViewModel >> coders [
	<return: #GtCodersModel>
	
	self
		deprecated: 'Please use #coder instead'
		transformWith: '`@receiver coders' -> '`@receiver coder'.
	
	^ coder
]

{ #category : #accessing }
GtMultipleCodersViewModel >> coders: aGtCodersModel [
	self
		deprecated: 'Please use coder: instead.'
		transformWith:
			'`@receiver coders: `@statements1'
				-> '`@receiver coder: `@statements1'.
				
	self coder: aGtCodersModel
]

{ #category : #accessing }
GtMultipleCodersViewModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #initialization }
GtMultipleCodersViewModel >> initialize [
	super initialize.
	
	coderUIModels := #()
]

{ #category : #updating }
GtMultipleCodersViewModel >> updateCoderUIModels [
	| aMappingOfCoderToCoderUI |
	
	aMappingOfCoderToCoderUI := IdentityDictionary new.
	coderUIModels do: [ :eachCoderUIModel |
		aMappingOfCoderToCoderUI at: eachCoderUIModel coder put: eachCoderUIModel ].
	
	coderUIModels := coder coders collect: [ :eachCoder |
		aMappingOfCoderToCoderUI
			at: eachCoder
			ifAbsent: [ self coderUIModelFor: eachCoder ] ]
]
