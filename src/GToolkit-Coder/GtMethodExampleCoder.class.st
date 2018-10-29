Class {
	#name : #GtMethodExampleCoder,
	#superclass : #GtMethodCoder,
	#instVars : [
		'example'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'as yet unclassified' }
GtMethodExampleCoder class >> forExample: anExample [
	^ self new example: anExample 
]

{ #category : #'instance creation' }
GtMethodExampleCoder >> bodyStylerClass [
	^ BrRBExpandableExamplesMethodBodyTextStyler
]

{ #category : #'actions - toolbar' }
GtMethodExampleCoder >> contextActions [
	^ {(GtCoderAction new
		title: 'Run' translated;
		icon: BrGlamorousIcons play;
		action: [ self run ])}
]

{ #category : #accessing }
GtMethodExampleCoder >> example [
	^ example
]

{ #category : #accessing }
GtMethodExampleCoder >> example: anExample [
	example := anExample.
	self forMethod: anExample method
]

{ #category : #actions }
GtMethodExampleCoder >> run [
	example run
]
