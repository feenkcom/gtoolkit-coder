Class {
	#name : #GtCoderContextMenuContent,
	#superclass : #BrSimpleList,
	#category : #'GToolkit-Coder-UI'
}

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
					do: [ eachGtCoderContextMenuAction action cull: self anchor.
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
						do: [ :anEvent | hover cull: self anchor ] ].
			eachGtCoderContextMenuAction leaveAction
				ifNotNil: [ :leave | 
					element
						when: BlMouseLeaveEvent
						do: [ :anEvent | leave cull: self anchor ] ].
			element ];
		hFitContent;
		vFitContent
]
