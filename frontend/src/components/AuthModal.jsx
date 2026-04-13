import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';

const AuthModal = ({ isOpen, onClose }) => {
    const { login, register } = useAuth();
    const [mode, setMode] = useState('login'); // 'login' or 'register'
    const [form, setForm] = useState({ email: '', password: '', username: '', displayName: '' });
    const [error, setError] = useState(null);

    if (!isOpen) return null;

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError(null);
        try {
            if (mode === 'login') {
                await login(form.email, form.password);
            } else {
                await register(form.email, form.username, form.password, form.displayName);
            }
            onClose();
        } catch (err) {
            setError(err.response?.data || "An error occurred");
        }
    };

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
            <div className="bg-cine-panel border border-slate-700 w-full max-w-md rounded-xl shadow-2xl relative p-8">
                <button onClick={onClose} className="absolute right-4 top-4 text-slate-400 hover:text-white">✕</button>
                <h2 className="text-2xl font-bold mb-6 text-center">{mode === 'login' ? 'Welcome Back' : 'Create Account'}</h2>
                
                {error && <div className="p-3 mb-4 bg-rose-500/20 text-rose-400 rounded-md text-sm">{error}</div>}

                <form onSubmit={handleSubmit} className="flex flex-col gap-4">
                    <input type="email" placeholder="Email" required className="bg-slate-800/50 border border-slate-700 rounded-md p-3 focus:outline-none focus:border-cine-gold" 
                        onChange={e => setForm({...form, email: e.target.value})} />
                    
                    {mode === 'register' && (
                        <>
                            <input type="text" placeholder="Username" required minLength={3} maxLength={20} className="bg-slate-800/50 border border-slate-700 rounded-md p-3 focus:outline-none focus:border-cine-gold"
                                onChange={e => setForm({...form, username: e.target.value})} />
                            <input type="text" placeholder="Display Name (Optional)" className="bg-slate-800/50 border border-slate-700 rounded-md p-3 focus:outline-none focus:border-cine-gold"
                                onChange={e => setForm({...form, displayName: e.target.value})} />
                        </>
                    )}
                    
                    <input type="password" placeholder="Password" required minLength={8} className="bg-slate-800/50 border border-slate-700 rounded-md p-3 focus:outline-none focus:border-cine-gold"
                        onChange={e => setForm({...form, password: e.target.value})} />

                    <button type="submit" className="bg-cine-gold hover:bg-yellow-500 text-slate-900 font-bold p-3 rounded-md mt-2 transition-colors">
                        {mode === 'login' ? 'Sign In' : 'Sign Up'}
                    </button>
                </form>

                <div className="mt-6 text-center text-slate-400 text-sm">
                    {mode === 'login' ? (
                        <>Don't have an account? <button onClick={() => setMode('register')} className="text-cine-gold hover:underline">Sign up</button></>
                    ) : (
                        <>Already have an account? <button onClick={() => setMode('login')} className="text-cine-gold hover:underline">Sign in</button></>
                    )}
                </div>
            </div>
        </div>
    );
};

export default AuthModal;
