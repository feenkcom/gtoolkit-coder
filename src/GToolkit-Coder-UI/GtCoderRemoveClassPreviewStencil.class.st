Class {
	#name : #GtCoderRemoveClassPreviewStencil,
	#superclass : #BrStencil,
	#instVars : [
		'classToRemove',
		'menuModel'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> classExternalReferences [
	"Answer the references to the class, from methods that are not removed with it"

	^ GtCoderRemoveClassesPreviewStencil
		externalReferencesTo: {self classToRemove}
		removing: self classesToRemoveWithSubclasses
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> classToRemove [
	^ classToRemove
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> classToRemove: anObject [
	classToRemove := anObject
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> classesToRemoveWithSubclasses [
	"Answer the class and all its subclasses"

	^ self classToRemove withAllSubclasses asArray
]

{ #category : #'api - instantiation' }
GtCoderRemoveClassPreviewStencil >> create [
	| element |
	element := BrVerticalPane new fitContent.
	element
		addChild: (self newRemoveClassLabel
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
GtCoderRemoveClassPreviewStencil >> externalReferences [
	^ GtCoderRemoveClassesPreviewStencil 
			externalReferencesTo: self classesToRemoveWithSubclasses
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> hasSubclasses [
	^ self classToRemove subclasses notEmpty
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> menuModel [
	^ menuModel
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> menuModel: anObject [
	menuModel := anObject
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newButtonsElement [
	| pane |
	pane := BrHorizontalPane new fitContent.
	pane addChild: self newRemoveButton as: #removeButton.
	self hasSubclasses ifTrue: [ 
			pane addChild: self newRemoveHierarchyButton as: #removeHierarchyButton ].
	^ pane
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newDetailsLabel: aString [
	^ BrLabel new
		margin: (BlInsets left: 10 right: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
		text: aString asRopedText
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newReferencesAsyncElement [
	^ BrAsyncWidget new
			fitContent;
			stencil: [ self newReferencesContentElement ]
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newReferencesContentElement [
	| pane users references |
	references := self classExternalReferences size.
	users := self classToRemove isTrait
			ifFalse: [ 0 ]
			ifTrue: [ self classToRemove users size ].
			
	pane := BrVerticalPane new.
	pane fitContent.
	references > 0 ifTrue: [ 
			pane addChild: (self 
				newDetailsLabel: (GtCoderRemoveClassesPreviewStencil referencesDescription: references)) ].
				
	self hasSubclasses
		ifTrue: [ 
			pane addChild: (self newDetailsLabel: self subclassesWithReferencesDescription) ].
	
	users > 0 ifTrue: [ 
		pane addChild: (self newDetailsLabel: users printString 
			, ' user' 
			, (users > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) ].
						
	^ pane
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newRemoveButton [
	"Removing only the class is not possible if it has subclasses"

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
		disabled: self hasSubclasses;
		action: [ self menuModel ifNotNil: #hideAll.
			self removeClass ]
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newRemoveClassLabel [
	| labelText |
	labelText := 'Remove {1} {2}' format: { self classToRemove gtCoderTypeName. self classToRemove name }.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #private }
GtCoderRemoveClassPreviewStencil >> newRemoveHierarchyButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
		beSmallSize;
		margin: (BlInsets
				top: 10
				bottom: 10
				left: 0
				right: 10);
		icon: BrGlamorousVectorIcons bin;
		label: 'Remove hierarchy';
		action: [ self menuModel ifNotNil: #hideAll.
			self removeHierarchy ]
]

{ #category : #actions }
GtCoderRemoveClassPreviewStencil >> removeChange [
	^ GtRBRemoveClassChange remove: self classToRemove
]

{ #category : #actions }
GtCoderRemoveClassPreviewStencil >> removeClass [
	self removeChange gtExecuteWithUndo
]

{ #category : #actions }
GtCoderRemoveClassPreviewStencil >> removeHierarchy [
	self removeHierarchyChange gtExecuteWithUndo
]

{ #category : #actions }
GtCoderRemoveClassPreviewStencil >> removeHierarchyChange [
	^ GtCoderRemoveClassesPreviewStencil
		removeChangeForClasses: self classesToRemoveWithSubclasses
		named: ('Remove {1} and {2}' format: {self classToRemove name. self subclassesDescription})
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> subclassesDescription [
	| aCount |
	aCount := self subclassesToRemove size.
	^ aCount printString , (aCount = 1 ifTrue: [ ' subclass' ] ifFalse: [ ' subclasses' ])
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> subclassesExternalReferences [
	^ GtCoderRemoveClassesPreviewStencil
		externalReferencesTo: self subclassesToRemove
		removing: self classesToRemoveWithSubclasses
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> subclassesToRemove [
	^ self classToRemove allSubclasses
]

{ #category : #accessing }
GtCoderRemoveClassPreviewStencil >> subclassesWithReferencesDescription [
	^ '{1} with {2}'
		format: {self subclassesDescription.
				GtCoderRemoveClassesPreviewStencil
					referencesDescription: self subclassesExternalReferences size}
]
