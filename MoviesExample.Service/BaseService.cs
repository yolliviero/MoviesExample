/*
Copyright (c) 2011 Ulf Björklund, http://average-uffe.blogspot.com/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
using System;
using System.Collections.Generic;
using System.Linq;
using MoviesExample.Core.Model;
using MoviesExample.Core.Interfaces.Data;
using MoviesExample.Core.Interfaces.Service;

namespace MoviesExample.Service
{
    /// <summary>
    /// Base for all services... If you need specific businesslogic
    /// override these methods in inherited classes and implement the logic there.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class BaseService<T> : IService<T> where T : PersistentEntity
    {
        protected IRepository<T> Repository;

        protected IUnitOfWork UnitOfWork;

        protected BaseService(IUnitOfWork unitOfWork)
        {
            this.UnitOfWork = unitOfWork;
        }

        public virtual IQueryable<T> GetAll()
        {
            return this.Repository.GetAll();
        }
		
		public virtual IQueryable<T> GetAllReadOnly()
		{
			return this.Repository.GetAllReadOnly();
		}

        public virtual T GetById(int id)
        {
            return this.Repository.GetById(id);
        }

        public virtual void SaveOrUpdate(T entity)
        {
            this.Repository.SaveOrUpdate(entity);
            this.UnitOfWork.Commit();
        }

        public virtual void Delete(T entity)
        {
            this.Repository.Delete(entity);
            this.UnitOfWork.Commit();
        }

        public virtual IEnumerable<T> Find(System.Linq.Expressions.Expression<Func<T, bool>> expression, int maxHits = 100)
        {
            return this.Repository.Find(expression, maxHits);
        }
    }
}