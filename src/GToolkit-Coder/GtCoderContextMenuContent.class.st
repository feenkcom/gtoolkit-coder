Class {
	#name : #GtCoderContextMenuContent,
	#superclass : #BrSimpleList,
	#instVars : [
		'editorElement'
	],
	#category : #'GToolkit-Coder-UIOld'
}

{ #category : #defaults }
GtCoderContextMenuContent >> defaultContextMenuActionName [
	^ #contextMenuAction
]

{ #category : #defaults }
GtCoderContextMenuContent >> defaultLabelChildName [
	^ #label
]

{ #category : #'api - accessing' }
GtCoderContextMenuContent >> editorElement [
	<return: #BrEditorElement>
	^ editorElement
]

{ #category : #'api - accessing' }
GtCoderContextMenuContent >> editorElement: anEditorElement [
	self 
		assert: [ anEditorElement isNotNil ] 
		description: [ 'Editor element must be non-nil' ].
	editorElement := anEditorElement
]

{ #category : #initialization }
GtCoderContextMenuContent >> initialize [
	super initialize.
	self
		stencil: [ :eachGtCoderContextMenuAction | 
			| element |
			element := BlElement new.
			element
				viewModel:
					(BrInteractiveModel new
						withHover;
						yourself);
				look:
					(BrInteractiveCommonLook new
						default: [ :f | f background: Color transparent ];
						hovered: [ :f | f background: BrGlamorousColors defaultButtonBorderColor ];
						yourself);
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				padding: (BlInsets all: 5);
				addEventHandlerOn: BlClickEvent
					do: [ eachGtCoderContextMenuAction action cull: self editorElement cull: self anchor.
					self anchor
						dispatchEvent:
							(BrContextMenuHideWish new
								anchor: self anchor;
								yourself) ];
				addChild:
					(BrLabel new
						look: BrGlamorousLabelLook;
						text: eachGtCoderContextMenuAction title;
						yourself).
			eachGtCoderContextMenuAction hoverAction
				ifNotNil: [ :hover | 
					element
						when: BlMouseEnterEvent
						do: [ :anEvent | hover cull: self editorElement cull: self anchor ] ].
			eachGtCoderContextMenuAction leaveAction
				ifNotNil: [ :leave | 
					element
						when: BlMouseLeaveEvent
						do: [ :anEvent | leave cull: self editorElement cull: self anchor ] ].
			element ];
		hFitContent;
		vFitContent
]

{ #category : #'instance creation' }
GtCoderContextMenuContent >> newItemElement [
	| anElement |
	anElement := BlElement new
		viewModel: (BrInteractiveModel new withHover);
		look: (BrInteractiveCommonLook new
			default: [ :f | f background: Color transparent ];
			hovered: [ :f | f background: BrGlamorousColors defaultButtonBorderColor ]);
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent.
			c padding: (BlInsets all: 5) ];
		addEventHandlerOn: BlClickEvent
			do: [ :anEvent | self onClickEvent: anEvent ];
		addChild: (BrLabel new look: BrGlamorousLabelLook) as: self defaultLabelChildName
]

{ #category : #hooks }
GtCoderContextMenuContent >> onClickEvent: anEvent [
	anEvent currentTarget userData 
		at: self defaultContextMenuActionName
		ifPresent: [ :aMenuAction | 
			aMenuAction action cull: self anchor.
			self anchor dispatchEvent: (BrContextMenuHideWish new
				anchor: self anchor) ]
]
