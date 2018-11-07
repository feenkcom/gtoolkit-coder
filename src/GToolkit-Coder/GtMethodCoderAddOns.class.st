Class {
	#name : #GtMethodCoderAddOns,
	#superclass : #Object,
	#instVars : [
		'bodyStylers',
		'patternStylers',
		'contextActions',
		'mainActions',
		'modified'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #stylers }
GtMethodCoderAddOns >> addBodyStyler: aStyler [
	(bodyStylers anySatisfy: [ :each | each class = aStyler class ])
		ifTrue: [ ^ self ].
	bodyStylers add: aStyler.
	modified add: #bodyStylers
]

{ #category : #actions }
GtMethodCoderAddOns >> addContextAction: aString icon: anIcon action: aBlock [
	| newAction index |
	newAction := GtCoderAction new
		title: aString;
		icon: anIcon;
		action: aBlock.
	index := (1 to: contextActions size) detect: [ :i | (contextActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ contextActions add: newAction ]
		ifFalse: [ contextActions at: index put: newAction ].
	modified add: #contextActions
]

{ #category : #actions }
GtMethodCoderAddOns >> addMainAction: aString icon: anIcon action: aBlock [
	| newAction index |
	newAction := GtCoderAction new
		title: aString;
		icon: anIcon;
		action: aBlock.
	index := (1 to: mainActions size) detect: [ :i | (mainActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ mainActions add: newAction ]
		ifFalse: [ mainActions at: index put: newAction ].
	modified add: #mainActions
]

{ #category : #stylers }
GtMethodCoderAddOns >> addPatternStyler: aStyler [
	(patternStylers anySatisfy: [ :each | each class = aStyler class ])
		ifTrue: [ ^ self ].
	patternStylers add: aStyler.
	modified add: #patternStylers
]

{ #category : #accessing }
GtMethodCoderAddOns >> bodyStylers [
	^ bodyStylers
]

{ #category : #changes }
GtMethodCoderAddOns >> changesDo: aBlock [
	modified do: aBlock
]

{ #category : #changes }
GtMethodCoderAddOns >> clearChanges [
	modified := Set new
]

{ #category : #accessing }
GtMethodCoderAddOns >> contextActions [
	^ contextActions
]

{ #category : #'initialize-release' }
GtMethodCoderAddOns >> initialize [
	super initialize.
	contextActions := OrderedCollection new.
	mainActions := OrderedCollection new.
	patternStylers := OrderedCollection new.
	bodyStylers := OrderedCollection new.
	modified := Set new
]

{ #category : #accessing }
GtMethodCoderAddOns >> mainActions [
	^ mainActions
]

{ #category : #accessing }
GtMethodCoderAddOns >> patternStylers [
	^ patternStylers
]

{ #category : #stylers }
GtMethodCoderAddOns >> removeBodyStylerOfType: aClass [
	| styler |
	styler := bodyStylers detect: [ :each | each class = aClass ] ifNone: [  ].
	styler isNil
		ifTrue: [ ^ self ].
	bodyStylers remove: styler.
	modified add: #bodyStylers
]

{ #category : #actions }
GtMethodCoderAddOns >> removeContextAction: aString [
	| index |
	index := (1 to: contextActions size) detect: [ :i | (contextActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ ^ self ].
	contextActions removeAt: index.
	modified add: #contextActions
]

{ #category : #actions }
GtMethodCoderAddOns >> removeMainAction: aString [
	| index |
	index := (1 to: mainActions size) detect: [ :i | (mainActions at: i) title = aString ] ifNone: [ 0 ].
	index = 0
		ifTrue: [ ^ self ].
	mainActions removeAt: index.
	modified add: #mainActions
]

{ #category : #stylers }
GtMethodCoderAddOns >> removePatternStylerOfType: aClass [
	| styler |
	styler := patternStylers detect: [ :each | each class = aClass ] ifNone: [  ].
	styler isNil
		ifTrue: [ ^ self ].
	patternStylers remove: styler.
	modified add: #patternStylers
]
