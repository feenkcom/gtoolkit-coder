Class {
	#name : #GtCoderContextMenuContent,
	#superclass : #BrSimpleList,
	#instVars : [
		'editorElement'
	],
	#category : #'GToolkit-Coder-UI-Basic'
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
					do: [
						eachGtCoderContextMenuAction action cull: self editorElement cull: self anchor.
						self fireEvent: BrDropdownHideWish new.
						self fireEvent: BrContextMenuHideWish new ];
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
			
			eachGtCoderContextMenuAction name
				ifNotNil: [ :anActionName | element containerName: anActionName ].
			
			element ];
		hFitContent;
		vFitContent
]
