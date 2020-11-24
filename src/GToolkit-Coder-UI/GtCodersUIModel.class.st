Class {
	#name : #GtCodersUIModel,
	#superclass : #Object,
	#instVars : [
		'coder',
		'coderUIModels'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtCodersUIModel >> announcer [
	self
		deprecated: 'Use #coder announcer instead.'
		transformWith: '`@receiver announcer' -> '`@receiver coder announcer'.

	^ self coder announcer
]

{ #category : #converting }
GtCodersUIModel >> asCoderUIModel [
	^ self
]

{ #category : #converting }
GtCodersUIModel >> asElement [
	^ self elementClass new
		codersUIModel: self;
		yourself
]

{ #category : #accessing }
GtCodersUIModel >> coder [
	<return: #GtCodersModel>
	
	^ coder
]

{ #category : #accessing }
GtCodersUIModel >> coder: aGtCodersModel [
	coder := aGtCodersModel.
	self updateCoderUIModels
]

{ #category : #updating }
GtCodersUIModel >> coderUIModelFor: aCoder [
	^ aCoder asCoderUIModel
]

{ #category : #accessing }
GtCodersUIModel >> coderUIModels [
	^ coderUIModels
]

{ #category : #accessing }
GtCodersUIModel >> coders [
	<return: #GtCodersModel>
	
	self
		deprecated: 'Please use #coder instead'
		transformWith: '`@receiver coders' -> '`@receiver coder'.
	
	^ coder
]

{ #category : #accessing }
GtCodersUIModel >> coders: aGtCodersModel [
	self
		deprecated: 'Please use coder: instead.'
		transformWith:
			'`@receiver coders: `@statements1'
				-> '`@receiver coder: `@statements1'.
				
	self coder: aGtCodersModel
]

{ #category : #accessing }
GtCodersUIModel >> elementClass [
	^ self subclassResponsibility
]

{ #category : #initialization }
GtCodersUIModel >> initialize [
	super initialize.
	
	coderUIModels := #()
]

{ #category : #updating }
GtCodersUIModel >> updateCoderUIModels [
	| aMappingOfCoderToCoderUI |
	
	aMappingOfCoderToCoderUI := IdentityDictionary new.
	coderUIModels do: [ :eachCoderUIModel |
		aMappingOfCoderToCoderUI at: eachCoderUIModel coder put: eachCoderUIModel ].
	
	coderUIModels := coder coders collect: [ :eachCoder |
		aMappingOfCoderToCoderUI
			at: eachCoder
			ifAbsent: [ self coderUIModelFor: eachCoder ] ]
]
