Class {
	#name : #GtCoderRemoveClassesPreviewStencil,
	#superclass : #BrStencil,
	#instVars : [
		'classesToRemove',
		'menuModel'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'instance creation' }
GtCoderRemoveClassesPreviewStencil class >> externalReferencesTo: someClasses [
	^ self externalReferencesTo: someClasses removing: someClasses
]

{ #category : #'instance creation' }
GtCoderRemoveClassesPreviewStencil class >> externalReferencesTo: someClasses removing: allRemovedClasses [
	| allRemovedClassesArray |
	allRemovedClassesArray := allRemovedClasses asArray.
	^ someClasses asArray
		flatCollect: [ :eachClass | 
			(GtPharoIndex current globalVariableReferencesTo: eachClass binding)
				reject: [ :eachMethod | allRemovedClassesArray includes: eachMethod methodClass instanceSide ] ]
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil class >> referencesDescription: aCount [
	^ aCount printString , (aCount = 1 ifTrue: [ ' reference' ] ifFalse: [ ' references' ])
]

{ #category : #'instance creation' }
GtCoderRemoveClassesPreviewStencil class >> removeChangeForClasses: someClasses named: aString [
	"Answer a composite change that removes subclasses before their superclasses.
	Then no removed class is left with an obsolete superclass,
	and the undo restores superclasses before their subclasses.
	References to the classes do not prevent their removal."

	^ RBCompositeRefactoryChange new
		name: aString;
		changes: ((someClasses asArray
				sorted: [ :a :b | a allSuperclasses size >= b allSuperclasses size ])
				collect: [ :eachClass | GtRBRemoveClassChange remove: eachClass ]) asOrderedCollection
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> classesToRemove [
	^ classesToRemove
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> classesToRemove: anObject [
	classesToRemove := anObject
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> classesToRemoveWithSubclasses [
	^ self classesToRemove asArray , self subclassesNotSelected
]

{ #category : #'api - instantiation' }
GtCoderRemoveClassesPreviewStencil >> create [
	| element |
	element := BrVerticalPane new fitContent.
	element
		addChild: (self newRemoveSeveralClassesLabel
				margin: (BlInsets
						top: 10
						bottom: 0
						left: 10
						right: 10)).
	element addChild: self newReferencesAsyncElement.
	element addChild: self newButtonsElement.
	^ element
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> externalReferences [
	^ self class externalReferencesTo: self classesToRemoveWithSubclasses
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> hasSubclassesNotSelected [
	^ self subclassesNotSelected notEmpty
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> menuModel [
	^ menuModel
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> menuModel: anObject [
	menuModel := anObject
]

{ #category : #private }
GtCoderRemoveClassesPreviewStencil >> newButtonsElement [
	| pane |
	pane := BrHorizontalPane new fitContent.
	pane addChild: self newRemoveButton as: #removeButton.
	self hasSubclassesNotSelected ifTrue: [ 
		pane addChild: self newRemoveWithSubclassesButton as: #removeWithSubclassesButton ].
	^ pane
]

{ #category : #private }
GtCoderRemoveClassesPreviewStencil >> newDetailsLabel: aString [
	^ BrLabel new
		margin: (BlInsets left: 10 right: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
		text: aString asRopedText
]

{ #category : #private }
GtCoderRemoveClassesPreviewStencil >> newReferencesAsyncElement [
	^ BrAsyncWidget new
		fitContent;
		stencil: [ 
			| pane references |
			references := self selectedClassesExternalReferences size.
			pane := BrVerticalPane new.
			pane fitContent.
			references > 0 ifTrue: [ 
				pane addChild: (self newDetailsLabel: (self class 
					referencesDescription: references)) ].
				
			self hasSubclassesNotSelected ifTrue: [ 
				pane addChild: (self 
					newDetailsLabel: self subclassesWithReferencesDescription) ].
			pane ]
]

{ #category : #private }
GtCoderRemoveClassesPreviewStencil >> newRemoveButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		beSmallSize;
		margin: (BlInsets
				top: 10
				bottom: 10
				left: 10
				right: 10);
		icon: BrGlamorousVectorIcons bin;
		label: 'Remove';
		disabled: self hasSubclassesNotSelected;
		action: [ self menuModel ifNotNil: #hideAll.
			self removeClasses ]
]

{ #category : #private }
GtCoderRemoveClassesPreviewStencil >> newRemoveSeveralClassesLabel [
	| labelText |
	labelText := 'Remove {1} classes' format: {self classesToRemove size}.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #private }
GtCoderRemoveClassesPreviewStencil >> newRemoveWithSubclassesButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		beSmallSize;
		margin: (BlInsets
				top: 10
				bottom: 10
				left: 0
				right: 10);
		icon: BrGlamorousVectorIcons bin;
		label: 'Remove with subclasses';
		action: [ self menuModel ifNotNil: #hideAll.
			self removeWithSubclasses ]
]

{ #category : #actions }
GtCoderRemoveClassesPreviewStencil >> removeChange [
	^ self class
		removeChangeForClasses: self classesToRemove
		named: ('Remove {1} classes' format: {self classesToRemove size})
]

{ #category : #actions }
GtCoderRemoveClassesPreviewStencil >> removeClasses [
	self removeChange gtExecuteWithUndo
]

{ #category : #actions }
GtCoderRemoveClassesPreviewStencil >> removeWithSubclasses [
	self removeWithSubclassesChange gtExecuteWithUndo
]

{ #category : #actions }
GtCoderRemoveClassesPreviewStencil >> removeWithSubclassesChange [
	^ self class
		removeChangeForClasses: self classesToRemoveWithSubclasses
		named: ('Remove {1} classes and {2}'
				format: {self classesToRemove size.
						self subclassesDescription})
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> selectedClassesExternalReferences [
	^ self class
		externalReferencesTo: self classesToRemove
		removing: self classesToRemoveWithSubclasses
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> subclassesDescription [
	| aCount |
	aCount := self subclassesNotSelected size.
	^ aCount printString , (aCount = 1 ifTrue: [ ' subclass' ] ifFalse: [ ' subclasses' ])
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> subclassesExternalReferences [
	^ self class
		externalReferencesTo: self subclassesNotSelected
		removing: self classesToRemoveWithSubclasses
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> subclassesNotSelected [
	| someClasses |
	someClasses := self classesToRemove asArray.
	^ ((someClasses flatCollect: [ :eachClass | eachClass allSubclasses ]) asSet
		reject: [ :eachClass | someClasses includes: eachClass ]) asArray
]

{ #category : #accessing }
GtCoderRemoveClassesPreviewStencil >> subclassesWithReferencesDescription [
	^ '{1} with {2}'
		format: {self subclassesDescription.
				self class referencesDescription: self subclassesExternalReferences size}
]
