Class {
	#name : #GtBehaviorCoderActionsElement,
	#superclass : #GtCoderActionsElement,
	#instVars : [
		'behaviorCoderViewModel',
		'toolbarElement',
		'previewsElement'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
GtBehaviorCoderActionsElement >> addPreviews [
	previewsElement addChildren:
		(self coderViewModel previews
			collect: [ :aGtCoderPreview | 
				| addOnPreviewElement |
				addOnPreviewElement :=  aGtCoderPreview stencil asElement .
				aGtCoderPreview dataBinder
					element: addOnPreviewElement;
					coderViewModel: self behaviorCoderViewModel;
					build.

				addOnPreviewElement])
]

{ #category : #accessing }
GtBehaviorCoderActionsElement >> addToolbarActions [
	toolbarElement addItems:
		(self coderViewModel mainActions
			collect: [ :aGtCoderAction | 
				self flag: 'Temporary hack. Coder should to Phlow actions'.
				aGtCoderAction buildElementIn: self ])
]

{ #category : #accessing }
GtBehaviorCoderActionsElement >> behaviorCoderViewModel [
	^ behaviorCoderViewModel
]

{ #category : #accessing }
GtBehaviorCoderActionsElement >> behaviorCoderViewModel: aCoderViewModel [
	
	behaviorCoderViewModel ifNotNil: [ self unsubscribeFromBehaviourCoderViewModel ].
	
	behaviorCoderViewModel := aCoderViewModel.
	
	self subscribeToBehaviorCoderViewModel.
	self onBehaviourCoderViewModelChanged
]

{ #category : #accessing }
GtBehaviorCoderActionsElement >> coderViewModel [ 
	^ self behaviorCoderViewModel
]

{ #category : #accessing }
GtBehaviorCoderActionsElement >> coderViewModel: aCoderViewModel [
	self behaviorCoderViewModel: aCoderViewModel
]

{ #category : #initialization }
GtBehaviorCoderActionsElement >> initialize [
	super initialize.
	
	self layout: BlLinearLayout horizontal.
	self padding: (BlInsets empty).
	self constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical fitContent ].

	previewsElement := BrHorizontalPane new
		fitContent;
		alignCenterLeft;
		cellSpacing: 2.
		
	toolbarElement := self newToolbarElement 
		labeled: 'Main toolbar'.

	self addChildren: { previewsElement. toolbarElement }
]

{ #category : #'building - widgets' }
GtBehaviorCoderActionsElement >> newToolbarElement [
	<return: #BrToolbar>

	^ BrToolbar new
		aptitude: (BrGlamorousToolbarAptitude new 
			spacing: 0);
		padding: (BlInsets empty);
		margin: (BlInsets empty)
]

{ #category : #callbacks }
GtBehaviorCoderActionsElement >> onBehaviourCoderViewModelChanged [
	self updatePreviews.
	self updateToolbarActions
]

{ #category : #updating }
GtBehaviorCoderActionsElement >> removePreviews [
	previewsElement removeChildren
]

{ #category : #updating }
GtBehaviorCoderActionsElement >> removeToolbarActions [
	toolbarElement numberOfItems 
		timesRepeat: [ toolbarElement removeItemAt: 1 ]
]

{ #category : #subscriptions }
GtBehaviorCoderActionsElement >> subscribeToBehaviorCoderViewModel [

	self behaviorCoderViewModel weak
		when: GtPharoBehaviorCoderViewModelAddonsChangedAnnouncement 
		send: #updateContent 
		to: self
]

{ #category : #subscriptions }
GtBehaviorCoderActionsElement >> unsubscribeFromBehaviourCoderViewModel [
	self behaviorCoderViewModel unsubscribe: self
]

{ #category : #updating }
GtBehaviorCoderActionsElement >> updateContent [
	self enqueueTask: (BlTaskAction new
		action: [			
			self updatePreviews.
			self updateToolbarActions ])
]

{ #category : #updating }
GtBehaviorCoderActionsElement >> updatePreviews [
	self removePreviews.
	self addPreviews
]

{ #category : #updating }
GtBehaviorCoderActionsElement >> updateToolbarActions [
	self removeToolbarActions.
	self addToolbarActions 
]
