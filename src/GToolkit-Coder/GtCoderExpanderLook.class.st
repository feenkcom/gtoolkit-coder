Class {
	#name : #GtCoderExpanderLook,
	#superclass : #BrGlamorousExpanderLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtCoderExpanderLook >> initialize [
	| shadowLook focusedShadowLook expanded |
	super initialize.
	shadowLook := BrShadowLook new.
	focusedShadowLook := BrShadowLook new color: (BrGlamorousColors primaryBorderColor alpha: 0.4).
	expanded := false.
	self
		add:
			(BrInteractiveLook new
				style: [ :aStyler | 
					aStyler default: [ sidebar background: Color veryVeryLightGray ].
					aStyler
						collapsed: [ shadowLook isAttachedToWidget
								ifTrue: [ self remove: shadowLook ].
							focusedShadowLook isAttachedToWidget
								ifTrue: [ self remove: focusedShadowLook ].
							expanded := false ].
					aStyler
						expanded: [ shadowLook isAttachedToWidget
								ifTrue: [ self remove: shadowLook ].
							focusedShadowLook isAttachedToWidget
								ifTrue: [ self remove: focusedShadowLook ].
							widget hasFocus
								ifTrue: [ self add: focusedShadowLook ]
								ifFalse: [ self add: shadowLook ].
							expanded := true ].
					aStyler
						unfocused: [ sidebar background: Color veryVeryLightGray.
							shadowLook isAttachedToWidget
								ifTrue: [ self remove: shadowLook ].
							focusedShadowLook isAttachedToWidget
								ifTrue: [ self remove: focusedShadowLook ].
							expanded
								ifTrue: [ self add: shadowLook ] ].
					aStyler
						focused: [ sidebar background: (BrGlamorousColors primaryBorderColor alpha: 0.4).
							shadowLook isAttachedToWidget
								ifTrue: [ self remove: shadowLook ].
							focusedShadowLook isAttachedToWidget
								ifTrue: [ self remove: focusedShadowLook ].
							expanded
								ifTrue: [ self add: focusedShadowLook ] ] ]).
	toggle
		background: Color transparent;
		constraintsDo: [ :c | c vertical matchParent ].
	toggle children first constraintsDo: [ :c | c linear vertical alignTop ]
]
