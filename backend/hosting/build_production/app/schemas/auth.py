from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime

class UserLogin(BaseModel):
    """User login request schema"""
    email_or_username: str = Field(..., description="Email or username")
    password: str = Field(..., min_length=6, description="Password")

class UserRegister(BaseModel):
    """User registration request schema"""
    email: EmailStr = Field(..., description="User email")
    username: str = Field(..., min_length=3, max_length=50, description="Username")
    password: str = Field(..., min_length=6, description="Password")
    first_name: Optional[str] = Field(None, max_length=100, description="First name")
    last_name: Optional[str] = Field(None, max_length=100, description="Last name")

class UserResponse(BaseModel):
    """User response schema"""
    id: str
    email: str
    username: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    is_active: bool
    is_verified: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class TokenResponse(BaseModel):
    """Token response schema"""
    access_token: str
    refresh_token: str
    token_type: str
    user: UserResponse

class PasswordChange(BaseModel):
    """Password change request schema"""
    current_password: str = Field(..., description="Current password")
    new_password: str = Field(..., min_length=6, description="New password")

class PasswordReset(BaseModel):
    """Password reset request schema"""
    reset_token: str = Field(..., description="Password reset token")
    new_password: str = Field(..., min_length=6, description="New password")
