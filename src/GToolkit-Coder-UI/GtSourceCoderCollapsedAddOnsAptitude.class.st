Class {
	#name : #GtSourceCoderCollapsedAddOnsAptitude,
	#superclass : #GtSourceCoderCollapsedTextAndExampleAptitude,
	#instVars : [
		'addOnsContainer'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #accessing }
GtSourceCoderCollapsedAddOnsAptitude >> initialize [

	super initialize.

	addOnsContainer := self newAddOnsContainer.

	container addChild: addOnsContainer.
]

{ #category : #'instance creation' }
GtSourceCoderCollapsedAddOnsAptitude >> newAddOnsContainer [

	^ BrHorizontalPane new fitContent
		margin: (BlInsets top: 4 left: 1 bottom: 1 right: 1)
]

{ #category : #'private - hooks' }
GtSourceCoderCollapsedAddOnsAptitude >> onCoderChanged: aGtSourceCoderUIModel [
	super onCoderChanged: aGtSourceCoderUIModel.
	self widget coderUIModel
		ifNotNil: [ :aPreviousCoder | aPreviousCoder coder announcer unsubscribe: self ].
	self updateAddonsFor: aGtSourceCoderUIModel.
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedAddOnsAptitude >> updateAddon: anAddOn coderUIModel: aGtSourceCoderUIModel [ 
	| anElement |
	anElement := anAddOn stencilBuilder 
		coderUIModel: aGtSourceCoderUIModel;
		build.
	anElement ifNil: [ ^ self ].
	addOnsContainer addChild: anElement asElement.
]

{ #category : #'private - updating' }
GtSourceCoderCollapsedAddOnsAptitude >> updateAddonsFor: aGtSourceCoderUIModel [
	self sourceCoderUIModel addOns then: [ :theComputedAddOns |
		addOnsContainer enqueueTask: (BlTaskAction new action: [
			addOnsContainer removeChildren.
			theComputedAddOns previews do: [ :eachAddOn | 
				self updateAddon: eachAddOn coderUIModel: aGtSourceCoderUIModel ] ])]
]
